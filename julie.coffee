# src = """
# ( begin 
#   ( def foo ( x ) ( + x 5 ) )
#   ( foo 4 )
# )
#"""

src = """
( begin 
  ( def r 5 )
  ( def foo ( + r 5 ) )
  ( if ( = foo 11 ) 
    ( puts 1 )
    ( puts 2 )
  )
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

    when "if"
      [_,_cond,_then,_else] = exp
      if evalle _cond,env
        return evalle _then, env
      else 
        return evalle _else, env

    when "+"
      [_,_exps...] = exp
      sum = 0
      sum += evalle _exp, env for _exp in _exps
      return sum

    when "="
      [_,_exp_a,_exp_b] = exp
      console.log "asdf"
      return (evalle _exp_a, env ) == (evalle _exp_b, env )

    when "while"
      [_,_cond,_exp] = exp
      while evalle(_cond,env)
        evalle _exp, env

    when "puts"
      [_,_exps...] = exp
      console.log evalle _exp, env for _exp in _exps

    else # symbol or literal
      if /^[A-Za-z]+$/.test exp
        return env[exp]
      else
        return parseFloat exp












program = parse src
console.log JSON.stringify program, null, 2

env = {}
console.log evalle program, env

console.log "final env: ", env

