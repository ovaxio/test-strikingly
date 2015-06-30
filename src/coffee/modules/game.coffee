"use_strict"

Module = (debug, utils, WordsList, Word, $)->
  class Game extends debug
    _DEBUG_LOG_ and moduleName : 'Game'

    defaults =
      url: ''
      userId: ''
    _DEBUG_LOG_ and defaults.debug = 1

    nbTry = 11

    constructor: (options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 1, @

      @wordsList = new WordsList()

    callApi: (data)->
      _DEBUG_LOG_ and @log 'callApi', 2
      promise = $.ajax
        'url': @options.url
        'type': 'POST'
        'headers':
          'content-type': 'application/json'
        'data' : JSON.stringify data

      return promise

    start: ()->
      _DEBUG_LOG_ and @log 'start', 1
      data =
        'playerId' : @options.userId
        'action': 'startGame'

      promise = @callApi data
      .done (result)=>
        $.extend @, result

        # nextWord
        @nextWord()

      return promise

    nextWord: ()->
      _DEBUG_LOG_ and @log 'nextWord', 1

      @getResult()

      data =
        'sessionId' : @sessionId
        'action': 'nextWord'

      promise = @callApi data
      .done (result)=>
        console.log result.data
        @guessWord = new Word result.data.word, 0, 0

        @makeGuess()

      return promise

    makeGuess: ()->
      _DEBUG_LOG_ and @log 'makeGuess', 1
      @wordsList.makeGuess @guessWord

      data =
        'sessionId' : @sessionId
        'action' : 'guessWord'
        'guess' :  @guessWord.bestLetter.toUpperCase()

      promise = @callApi data
      .done (result)=>
        @guessWord.value = result.data.word
        @guessWord.wrongGuess = result.data.wrongGuessCountOfCurrentWord

        switch true
          when @guessWord.wrongGuess >= @data.numberOfGuessAllowedForEachWord or -1 == @guessWord.value.indexOf '*'
            console.log @guessWord
            @nextWord()
            true
          else
            @guessWord.regex = @guessWord.getRegex()
            # console.log @guessWord
            @makeGuess()

      return promise

    getResult: ()->
      _DEBUG_LOG_ and @log 'getResult', 1
      data =
        'sessionId' : @sessionId
        'action': 'getResult'

      promise = @callApi data
      .done (result)=>
        console.log result.data

      return promise

  return Game

do(root = @, factory = Module)->
  if define?.amd
    define ["inc/debug",
            "inc/utils",
            "modules/wordlist",
            "modules/word",
            "jquery"
          ], factory
  else
    root.WordsList = factory()
  return
