if !window._DEBUG_LOG_?
  window._DEBUG_LOG_ = true

define (require)->
  $        = require 'jquery'
  utils    = require 'inc/utils'
  WordList = require 'modules/wordlist'
  Game     = require 'modules/game'

  dic = new WordList()
  dic.done ()->
    game = new Game()

    # startGame
    game.start()


    # # guessWord
    # # while -1 != guessWord.value.indexOf '*'

    # guess = dic.makeGuess guessWord
    # .fail (err)->
    #   console.log err
    # .done ()->
    #   console.log guessWord

# if !window._DEBUG_LOG_?
#   window._DEBUG_LOG_ = true

# define (require)->
#   $        = require 'jquery'
#   utils    = require 'inc/utils'
#   WordList = require 'modules/wordlist'
#   Word     = require 'modules/word'

#   dic = new WordList()
#   dic.done ()->

#     # startGame

#     # nextWord
#     guessWord = new Word '*a**', 0, 0

#     # guessWord
#     # while -1 != guessWord.value.indexOf '*'
#     dic.makeGuess guessWord


