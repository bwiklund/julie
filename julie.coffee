# src = """
# ( begin 
#   ( def foo ( x ) ( + x 5 ) )
#   ( foo 4 )
# )
#"""

src = """
( begin 
  ( def r 5 )
  ( + r 5 )
)
"""



OPEN_PAREN = "("
CLOSE_PAREN = ")"


parse = (str) ->

  toks = src.split /[\s\n]+/

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











evalle = (exp,env={}) ->
  switch exp[0]

    when "begin"
      for _exp in exp[1..]
        ret = evalle _exp, env
      return ret

    when "def"
      [_,_var,_exp] = exp
      env[_var] = evalle _exp, env

    when "+"
      [_,_exps...] = exp
      sum = 0
      sum += evalle _exp, env for _exp in _exps
      return sum

    else # symbol or literal
      if /^[A-Za-z]+$/.test exp
        return env[exp]
      else
        return parseFloat exp












program = parse src
console.log JSON.stringify program, null, 2

env = {}
console.log evalle program, env

console.log env

