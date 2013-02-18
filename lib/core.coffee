# all logic is run in the scope of the VM, making @evalle available

lib = {}


adlib = (name,fn) -> lib[name] = fn


adlib "begin", (exp,env) ->
  for _exp in exp[1..]
    ret = @evalle _exp, env
  ret


adlib "def", (exp,env) ->
  [_,_var,_exp] = exp
  env[_var] = @evalle _exp, env


adlib "fun", (exp,env) ->
  [_,name,argnames,fn_exp] = exp

  adlib name, (exp,env) ->
    fn_args = exp[1..]
    # evaluate the arguments and put them into the global (wrong) scope
    for i in [0...argnames.length]
      env[ argnames[i] ] = @evalle fn_args[i], env
    @evalle fn_exp, env

  undefined


adlib "if", (exp,env) ->
  [_,_cond,_then,_else] = exp
  if @evalle _cond,env
    @evalle _then, env
  else 
    @evalle _else, env


adlib "+", (exp,env) ->
  [_,_exps...] = exp
  sum = 0
  sum += @evalle _exp, env for _exp in _exps
  sum


adlib "=", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  (@evalle _exp_a, env ) == (@evalle _exp_b, env )


adlib "<", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  (@evalle _exp_a, env ) < (@evalle _exp_b, env )


adlib "%", (exp,env) ->
  [_,_exp_a,_exp_b] = exp
  (@evalle _exp_a, env ) % (@evalle _exp_b, env )


adlib "push", (exp,env) ->
  [_,list,_exp] = exp
  env[list].push @evalle _exp, env
  list


adlib "while", (exp,env) ->
  [_,_cond,_exp] = exp
  while @evalle(_cond,env)
    @evalle _exp, env
  undefined


adlib "puts", (exp,env) ->
  [_,_exps...] = exp
  console.log @evalle _exp, env for _exp in _exps



module.exports = lib