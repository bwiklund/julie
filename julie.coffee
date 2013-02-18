# src = """
# ( begin 
#   ( def foo ( x ) ( + x 5 ) )
#   ( foo 4 )
# )
#"""

# allsrc = """
# ( begin 
#   ( def r 5 )
#   ( def foo ( + r 5 ) )
#   ( if ( = foo 11 ) 
#     ( puts 1 )
#     ( puts 2 )
#   )
#   ( def i 0 )
#   ( while ( < i 5 ) 
#     ( begin
#       ( puts i )
#       ( def i ( + i 1 ) )
#     )
#   )
# )
# """

# allWhitespc = """
# begin
#   def r 5
#   def foo
#     + r 5
#   if 
#     = foo 11
#     puts 1
#     puts 2
#   def i 0
#   while
#     < i 5
#     begin
#       puts i
#       def i
#         + i 1
# """

###

r = 5
foo = -> r + 5
puts if foo == 11 then 1 else 2
puts i for i in [0...5]

###



# primeSrc = """
# ( begin 
#   ( def i 3 )
#   ( while ( < i 100 ) 
#     ( begin
#       ( def d 2 )
#       ( def isprime 1 )
#       ( while ( < d i ) 
#         ( begin 
#           ( def remainder ( % i d ) )
#           ( if ( = 0 remainder )
#             ( begin
#               ( def isprime 0 )
#               ( def d i )
#             )
#             ( 0 )
#           )
#           ( def d ( + d 1 ) )
#         )
#       )
#       ( if isprime 
#         ( puts i )
#         ( 0 )
#       )
#       ( def i ( + i 1 ) )
#     )
#   )
#   ( i )
# )
# """



# funtionSrc = """
# ( begin
#   ( fun foo ( x ) ( + x 5 ) )
#   ( puts ( foo 10 ) )
# )
# """



#src = funtionSrc


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






#parse = (str) ->




lib = {}
adlib = (name,fn) -> lib[name] = fn

adlib "begin", (exp,env) ->
  for _exp in exp[1..]
    ret = evalle _exp, env
  return ret

adlib "def", (exp,env) ->
  [_,_var,_exp] = exp
  env[_var] = evalle _exp, env

adlib "fun", (exp,env) ->
  [_,name,argnames,fn_exp] = exp

  adlib name, (exp,env) ->
    fn_args = exp[1..]

    # evaluate the arguments and put them into the global (wrong) scope
    for i in [0...argnames.length]
      env[ argnames[i] ] = evalle fn_args[i], env
      #console.log argnames[i], evalle fn_args[i], env
    #for i in [0...argnames.length]
    #  env[argnames[i]]=argvs[i]
    return evalle fn_exp, env

  return undefined

adlib "if", (exp,env) ->
  [_,_cond,_then,_else] = exp
  if evalle _cond,env
    return evalle _then, env
  else 
    return evalle _else, env

adlib "+", (exp,env) ->
  [_,_exps...] = exp
  sum = 0
  sum += evalle _exp, env for _exp in _exps
  return sum

adlib "=", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  return (evalle _exp_a, env ) == (evalle _exp_b, env )

adlib "<", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  return (evalle _exp_a, env ) < (evalle _exp_b, env )

adlib "%", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  return (evalle _exp_a, env ) % (evalle _exp_b, env )

adlib "while", (exp,env) ->
  [_,_cond,_exp] = exp
  while evalle(_cond,env)
    evalle _exp, env
  return undefined

adlib "puts", (exp,env) ->
  [_,_exps...] = exp
  console.log evalle _exp, env for _exp in _exps





evalle = (exp,env={}) ->
  tok = exp[0]
  if lib[tok]?
    return lib[tok](exp,env)
  else # symbol or literal
    if /^[A-Za-z]+$/.test exp
      throw new Error("#{exp} is undefined") if !env[exp]?
      return env[exp]
    else
      return parseFloat exp










module.exports = (src) ->

  program = parse src
  console.log JSON.stringify program, null, 2

  env = {}
  exit = evalle program, env
  console.log "exit:", exit

  console.log "final env:", env

  exit

