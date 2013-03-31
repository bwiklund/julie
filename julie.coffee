#!/usr/bin/env coffee

# take a julie program as a string, and parse it into a tree of expressions
#
# "( foo ( a b ) ( baz ( + 1 2 ) ) )"
# becomes:
# ['foo',['a','b'],['baz',['+','1','2']]]

module.exports.parse = (str) ->
  OPEN_PAREN = "("
  CLOSE_PAREN = ")"
  
  toks = str.split /[\s\n]+/

  stack = []
  current = []

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

  current[0]


###

whitespace aware version of the parser. takes stuff like this:

begin
  + 1 2
  foo
    bar

and reads it as

( begin 
  ( + 1 2 )
  ( foo ( bar ) )
)

###

module.exports.parseWhitespace = (str) ->
  #
  stack = []
  current = []

  indentStack = [-1]

  for line in str.split /\n/
    indent = line.match(/^\s*/)[0].length

    # ignore empty lines
    if /^\s*$/.test line
      continue
    
    if indent > indentStack[-1..][0]
      stack.push current
      parent = current
      current = []
      parent.push current
      indentStack.push indent

    else
      # unwind stack
      while indent < indentStack[-1..][0]
        indentStack.pop()
        current = stack.pop()

      next = []
      stack[-1..][0].push next
      current = next

    # no matter what we just did, the current node gets some expressions
    current.push tok for tok in (" "+line+" ").split(/\s+/)[1...-1]

  stack.pop()
  


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


toJs = (program) ->
  console.log program


console.log process.argv