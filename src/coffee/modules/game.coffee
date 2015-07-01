"use_strict"

Module = (debug, utils, WordsList, Word, $)->
  class Game extends debug
    _DEBUG_LOG_ and moduleName : 'Game'

    defaults =
      url: ''
      userId: ''
    _DEBUG_LOG_ and defaults.debug = 1

    nbWord = 0
    resultDiv = $ '.result'

    constructor: (options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 0, @

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
      _DEBUG_LOG_ and @log 'start()', 1
      data =
        'playerId' : @options.userId
        'action': 'startGame'

      promise = @callApi data
      .done (result)=>
        $.extend @, result
        _DEBUG_LOG_ and @log 'start() > data = ', 0, result.data
        # nextWord
        @nextWord()

      return promise

    nextWord: ()->
      _DEBUG_LOG_ and @log 'nextWord', 1

      data =
        'sessionId' : @sessionId
        'action': 'nextWord'

      promise = @callApi data
      .done (result)=>
        _DEBUG_LOG_ and @log 'nextWord() > data = ', 0, result.data
        @guessWord = new Word result.data.word, 0, 0
        nbWord++
        @makeGuess()

      return promise

    makeGuess: ()->
      _DEBUG_LOG_ and @log 'makeGuess', 1
      @wordsList.makeGuess @guessWord, @.data.numberOfGuessAllowedForEachWord

      if @guessWord?.bestLetter?
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
              _DEBUG_LOG_ and @log 'makeGuess() > guessWord = ', 0, @guessWord
              _DEBUG_LOG_ and @log 'makeGuess() > nbGuessedWord = ', 1, nbWord
              _DEBUG_LOG_ and @log 'makeGuess() > numberOfWordsToGuess = ', 1, @data.numberOfWordsToGuess

              if nbWord < @data.numberOfWordsToGuess
                @getResult()
                resultDiv.append '<pre>'+JSON.stringify(@guessWord)+'</pre>'
                @nextWord()
              else
                @getResult()
                .done (result)=>
                  submitScore = window.prompt 'Do you want to submit your score of '+result.data.score+' (write \'yes\' to confirm)'
                  if 'yes' == submitScore
                    @submitResult()
            else
              @guessWord.regex = @guessWord.getRegex()
              @makeGuess()

        return promise

      _DEBUG_LOG_ and @log 'makeGuess() > guessWord = ', 0, @guessWord
      $
      @nextWord()
      return false

    getResult: ()->
      _DEBUG_LOG_ and @log 'getResult', 1
      data =
        'sessionId' : @sessionId
        'action': 'getResult'

      promise = @callApi data
      .done (result)=>
        _DEBUG_LOG_ and @log 'getResult() > data =', 0, result.data

      return promise

    submitResult: ()->
      _DEBUG_LOG_ and @log 'submitResult', 1
      data =
        'sessionId' : @sessionId
        'action': 'submitResult'

      promise = @callApi data
      .done (result)=>
        _DEBUG_LOG_ and @log 'submitResult() > data = ', 0, result.data

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
