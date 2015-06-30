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

    makeGuess : (guessWord)->
      _DEBUG_LOG_ and @log 'makeGuess', 2
      words = @getPossibleWords @allWords, guessWord
      # console.log words

      freq = @getLetterFreq words
      letters = @getSortedLetter freq

      letters = (char for char in letters when -1 == guessWord.value.indexOf(char))

      if guessWord.bestLetter?
        guessWord.wrongLetter += guessWord.bestLetter
        letters = (char for char in letters when -1 == guessWord.wrongLetter.indexOf(char))

      # console.log letters
      guessWord.bestLetter = letters.shift()


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
