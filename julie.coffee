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


###

begin
  + 1 2

###

module.exports.parseWhitespace = (str) ->
  #
  stack = []
  tree = []
  current = tree

  indentStack = [0]

  for line in str.split /\n/
    indent = line.match(/^\s*/)[0].length
    
    while indent > indentStack[-1..][0]
      stack.push current
      parent = current
      current = []
      parent.push current
      indentStack.push indent

    while indent < indentStack[-1..][0]
      indentStack.pop()

    # no matter what we just did, the current node gets some expressions
    current.push tok for tok in (" "+line).split(/\s+/)[1..]

    #else if indent < lastIndent
    #  current = stack.pop()
    #  current.push tok for tok in (" "+line).split(/\s+/)[1..]
    #else
    #  current.push tok for tok in (" "+line).split(/\s+/)[1..]


  tree
  #['begin',['+','1','2']]
  


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



