"use_strict"
if !window._DEBUG_LOG_?
  window._DEBUG_LOG_ = true


Module = (debug, utils)->
  class Bootstrap extends debug
    _DEBUG_LOG_ and moduleName : 'Bootstrap'

    defaults = {}
    _DEBUG_LOG_ and defaults.debug = 1

    constructor: (options= {})->
      @options = utils.extend defaults, options
      _DEBUG_LOG_ and @log 'constructor', 1, @

  return Bootstrap

do(root = @, factory = Module)->
  if define?.amd
    define ["debug", "utils"], factory
  else
    root.Bootstrap = factory()
  return
