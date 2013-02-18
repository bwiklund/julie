
julieInstance = (src) ->

  OPEN_PAREN = "("
  CLOSE_PAREN = ")"

  
  parse = (str) ->

    toks = str.split /[\s\n]+/

    stack = []
    tree = []
    current = tree

    for tok in toks
      if tok == OPEN_PAREN
        stack.push current
        parent = current
        current = []
        parent.push current
      else if tok == CLOSE_PAREN
        current = stack.pop()
      else
        current.push tok

    tree[0]




  




  class VM
    constructor: ->
      @lib = require './lib/core'

    evalle: (exp,env={}) =>
      tok = exp[0]
      if @lib[tok]?
        return @lib[tok].call(@,exp,env)
      else if exp == "[]"
        return []
      else # symbol or literal
        if /^[A-Za-z]+$/.test exp
          throw new Error("#{exp} is undefined") if !env[exp]?
          return env[exp]
        else
          return parseFloat exp


  program = parse src
  
  vm = new VM
  vm.evalle program






module.exports = (src) ->

  ji = julieInstance(src)
