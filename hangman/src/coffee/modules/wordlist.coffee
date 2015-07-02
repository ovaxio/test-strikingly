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

      letters = @getAllPossibleLetters guessWord, maxGuess

      if guessWord.bestLetter?
        guessWord.triedLetter += guessWord.bestLetter
        letters = (ch for ch in letters when -1 == guessWord.triedLetter.indexOf(ch))

      _DEBUG_LOG_ and @log ' > letters = ', 0, letters
      guessWord.bestLetter = letters.shift()

      _DEBUG_LOG_ and @log ' > guessWord =', 0, guessWord
      return guessWord.bestLetter

    getAllPossibleLetters: (guessWord, maxGuess)->
      _DEBUG_LOG_ and @log 'getAllPossibleLetters', 2
      if  guessWord.whichDic == 'alphabet'
        _DEBUG_LOG_ and @log ' > looking in '+guessWord.whichDic+' dic'
        return alphabet

      else
        possibleWords = @getPossibleWords this[guessWord.whichDic], guessWord

        if possibleWords.length <= 0
          #  change dictionnary
          guessWord.whichDic = @getNextDictionnary guessWord.whichDic
          return @getAllPossibleLetters guessWord, maxGuess

        else
          # normal behavior : have words in the current dictionnary
          return @getBestGuess guessWord.value, possibleWords

    getNextDictionnary: (dic)->
      _DEBUG_LOG_ and @log 'getNextDictionnary', 2
      switch dic
        when 'shortWords'
          # no more word in the short dictionnary shortWords
          _DEBUG_LOG_ and @log 'no more words in the dic > looking in '+dic+' dic'
          return 'allWords'

        when 'allWords'
          # no more word in the big dictionnary allWords
          _DEBUG_LOG_ and @log 'no more words in the '+dic+' dic > looking other letters'
          return 'alphabet'

        else
          return 'alphabet'

    getBestGuess: (pattern, possibleWords)->
      _DEBUG_LOG_ and @log 'getBestGuess', 2

      lettersFreq = @getLetterFreq possibleWords
      letters = @getSortedLetter lettersFreq
      lettersFiltered = (ch for ch in letters when -1 == pattern.indexOf(ch))

      return lettersFiltered

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
