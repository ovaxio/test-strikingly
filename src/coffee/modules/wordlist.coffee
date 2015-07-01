"use_strict"

Module = (debug, utils, $)->
  class WordsList extends debug
    _DEBUG_LOG_ and moduleName : 'WordsList'

    defaults = {}
    _DEBUG_LOG_ and defaults.debug = 0

    constructor: (options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 1, @


      @allWords = []
      dfd = $.Deferred()

      @getAllWords()
      .fail (err)=>
        _DEBUG_LOG_ and @log err
        return
      .done (data)=>
        _DEBUG_LOG_ and @log 'getAllWords > data received', 2
        @allWords = data.split "\n"
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

    # Different Algo to find the best score for the next guess
    # TODO: need to improve I think
    ###########################################################
    # getLetterScore: (freq, nbWord, stillTry)->
    #   _DEBUG_LOG_ and @log 'getLetterScore', 2

    #   score = {}
    #   for k, v of freq
    #     p = v / nbWord
    #     entropy = 0
    #     entropy -= p * Math.log p
    #     score[k] = (1 - stillTry) * p + (1 - stillTry) * entropy + stillTry * p + stillTry * entropy

      return score

    makeGuess : (guessWord, maxGuess)->
      _DEBUG_LOG_ and @log 'makeGuess', 2

      words = @getPossibleWords @allWords, guessWord
      freq = @getLetterFreq words

      # stillTry = guessWord.wrongGuess/maxGuess
      # score = @getLetterScore freq, words.length, stillTry
      # console.log score

      letters = @getSortedLetter freq
      letters = (char for char in letters when -1 == guessWord.value.indexOf(char))

      if guessWord.bestLetter?
        guessWord.wrongLetter += guessWord.bestLetter
        letters = (char for char in letters when -1 == guessWord.wrongLetter.indexOf(char))

      guessWord.bestLetter = letters.shift()
      _DEBUG_LOG_ and @log ' > guessWord =', 0, guessWord

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
