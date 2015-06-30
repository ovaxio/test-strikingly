"use_strict"

Module = (debug, utils, $)->
  class Word extends debug
    _DEBUG_LOG_ and moduleName : 'Word'

    defaults = {}
    _DEBUG_LOG_ and defaults.debug = 0

    starsRegExp = new RegExp '([*])', 'g'
    otherRegExp = new RegExp '([^*])', 'g'

    constructor: (@value, @wrongGuess, options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 1, @
      @nbLetterToGuess = 0
      @wrongLetter = ''

      @regex = @getRegex()

    getRegex: ()->
      _DEBUG_LOG_ and @log 'getRegex', 2
      pattern = false
      guessedLetters = ''

      @nbLetterToGuess = @getNbLetterToGuess()

      while (m = otherRegExp.exec(@value)) != null
        if m.index == starsRegExp.lastIndex
          starsRegExp.lastIndex++
        guessedLetters += m[0]

      re = '.'
      if guessedLetters.length > 0
        re = '[^'+guessedLetters+@wrongLetter+']'

      pattern = '^(' + @value.replace starsRegExp, re
      pattern+= ')$'

      return new RegExp pattern, 'i'

    getNbLetterToGuess: ()->
      nb = 0
      while (m = starsRegExp.exec(@value)) != null
        if m.index == starsRegExp.lastIndex
          starsRegExp.lastIndex++

        nb++
      return nb

  return Word

do(root = @, factory = Module)->
  if define?.amd
    define ["inc/debug",
            "inc/utils",
            "jquery"
          ], factory
  else
    root.WordsList = factory()
  return
