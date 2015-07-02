"use_strict"

Module = (debug, utils, $)->
  class WordsList extends debug
    _DEBUG_LOG_ and moduleName : 'WordsList'

    defaults = {}
    _DEBUG_LOG_ and defaults.debug = 0
    alphabet = 'abcdefghijklmnopqrstuvwxyz'

    constructor: (options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 1, @


      @allWords = []
      dfd = $.Deferred()


      pAll = @getAllWords()
      .fail (err)=>
        _DEBUG_LOG_ and @log err
        return
      .done (data)=>
        _DEBUG_LOG_ and @log 'getAllWords > data received', 2
        @allWords = data.split "\n"

      pShort = @getShortListWords()
      .fail (err)=>
        _DEBUG_LOG_ and @log err
        return
      .done (data)=>
        _DEBUG_LOG_ and @log 'getShortListWords > data received', 2
        @shortWords = data.split "\n"

      pMaster = $.when pAll, pShort
      .done ()->
        dfd.resolve()

      return dfd.promise @

    getAllWords: ()->
      _DEBUG_LOG_ and @log 'getAllWords', 2
      promise = $.ajax
        url: "assets/wordslist.txt",
        type: 'GET',
        dataType: 'text'

      _DEBUG_LOG_ and @log 'getAllWords > promise = ', 3, promise
      return promise

    getShortListWords: ()->
      _DEBUG_LOG_ and @log 'getShortListWords', 2
      promise = $.ajax
        url: "assets/wordslist-short.txt",
        type: 'GET',
        dataType: 'text'

      _DEBUG_LOG_ and @log 'getAllWords > promise = ', 3, promise
      return promise

    getWordWithLength: (list, ln)->
      _DEBUG_LOG_ and @log 'getWordWithLength', 2

      return (item for item in list when item.length == ln)

    getLetterFreq: (list)->
      _DEBUG_LOG_ and @log 'getLetterFreq', 2
      freq = {}
      for word in list
        for letter in word
          if !freq[letter]?
            freq[letter] = 0
          freq[letter]++

      return freq

    getSortedLetter: (arrayFreq)->
      _DEBUG_LOG_ and @log 'getSortedLetter', 2

      letters = Object.keys arrayFreq
      cb = (a, b)->
        if arrayFreq[a] > arrayFreq[b]
          return -1
        else
          return 1

      return letters.sort cb

    getPossibleWords: (list, unguessedWord)->
      _DEBUG_LOG_ and @log 'getPossibleWords', 2

      listWord = @getWordWithLength list, unguessedWord.value.length

      if unguessedWord.nbLetterToGuess < unguessedWord.value.length
        listWord = (item for item in listWord when unguessedWord.regex.test item)

      return listWord

    makeGuess : (guessWord, maxGuess)->
      _DEBUG_LOG_ and @log 'makeGuess', 2
      _DEBUG_LOG_ and @log ' > looking in '+guessWord.whichDic+' dic'

      if  guessWord.whichDic == 'alphabet'
        _DEBUG_LOG_ and @log ' > looking in '+guessWord.whichDic+' dic'
        letters = alphabet
      else
        possibleWords = @getPossibleWords this[guessWord.whichDic], guessWord
        if possibleWords.length <= 0 and guessWord.whichDic == 'shortWords' # no more word in the short dictionnary shortWords
          guessWord.whichDic = 'allWords'
          _DEBUG_LOG_ and @log 'no more words in the dic > looking in '+guessWord.whichDic+' dic'
          @makeGuess guessWord, maxGuess
          return

        if possibleWords.length <= 0 and guessWord.whichDic == 'allWords' # no more word in the big dictionnary allWords
          _DEBUG_LOG_ and @log 'no more words in the '+guessWord.whichDic+' dic > looking other letters'
          letters = alphabet
          guessWord.whichDic = 'alphabet'
        else
          letters = @getBestGuess guessWord.value, possibleWords

      if guessWord.bestLetter?
        guessWord.triedLetter += guessWord.bestLetter
        letters = (char for char in letters when -1 == guessWord.triedLetter.indexOf(char))

      _DEBUG_LOG_ and @log ' > letters = ', 0, letters
      guessWord.bestLetter = letters.shift()

      _DEBUG_LOG_ and @log ' > guessWord =', 0, guessWord
      return

    getBestGuess: (pattern, possibleWords)->
      freq = @getLetterFreq possibleWords
      letters = @getSortedLetter freq
      letters = (char for char in letters when -1 == pattern.indexOf(char))

      return letters

  return WordsList

do(root = @, factory = Module)->
  if define?.amd
    define ["inc/debug",
            "inc/utils",
            "jquery"
          ], factory
  else
    root.WordsList = factory()
  return
