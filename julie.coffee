# take a julie program as a string, and parse it into a tree of expressions

module.exports.parse = (str) ->
  OPEN_PAREN = "("
  CLOSE_PAREN = ")"
  
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




  


# represents an instance of our simple vm, hooking our library up to our evaluator and environment

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




module.exports.vm = -> new VM



