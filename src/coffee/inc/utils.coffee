"use_strict"

Module = ()->

  extend = (defaults, options)->
    extended = {}

    for prop of defaults
      if Object::hasOwnProperty.call(defaults, prop)
        extended[prop] = defaults[prop]

    for prop of options
      if Object::hasOwnProperty.call(options, prop)
        extended[prop] = options[prop]

    return extended

  utils = {}
  utils.extend = extend

  return utils

do(root = @, factory = Module)->
  if define?.amd
    define [], factory
  else
    root.Utils = factory()
  return