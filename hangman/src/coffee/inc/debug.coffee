"use_strict"
Module = ()->
  class Debug
    defaults =
      level: 0
      titleCSS: 'color: #8f0000; font-weight: bold'

    log: (msg, level, data...)->

      name = if @moduleName then @moduleName else @constructor.name
      title = '%c ' + name + ' >>'

      if typeof level == "undefined"
        level = defaults.level
      else if isNaN(level) and data.length == 0
        data = [level]
        level = defaults.level

      if @options.debug >= level
        if data.length == 0
          data = ''
        else if data.length == 1
          data = data[0]
        if console?
          console.log title, defaults.titleCSS, level, msg, data
      return

    error: (msg)->
      if console?
        console.error title, defaults.titleCSS, level, msg
      return

  return Debug

do(root = @, factory = Module)->
  if define?.amd
    define [], factory
  else
    root.Debug = factory()
  return
