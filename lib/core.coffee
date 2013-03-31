# all logic is run in the scope of the VM, making @evalle available

keywords =


  "begin": (exp,env) ->
    for _exp in exp[1..]
      ret = @evalle _exp, env
    ret


  "def": (exp,env) ->
    [_,_var,_exp] = exp
    env[_var] = @evalle _exp, env


  "fun": (exp,env) ->
    [_,name,argnames,fn_exp] = exp

    @lib[name] = (exp,env) ->
      fn_args = exp[1..]
      # evaluate the arguments and put them into the global (wrong) scope
      for i in [0...argnames.length]
        env[ argnames[i] ] = @evalle fn_args[i], env
      @evalle fn_exp, env

    undefined


  "if": (exp,env) ->
    [_,_cond,_then,_else] = exp
    if @evalle _cond,env
      @evalle _then, env
    else 
      @evalle _else, env


  "+": (exp,env) ->
    [_,_exps...] = exp
    sum = 0
    sum += @evalle _exp, env for _exp in _exps
    sum


  "=": (exp,env) ->
    [_,_exp_a,_exp_b] = exp
    (@evalle _exp_a, env ) == (@evalle _exp_b, env )


  "<": (exp,env) ->
    [_,_exp_a,_exp_b] = exp
    (@evalle _exp_a, env ) < (@evalle _exp_b, env )


  "%": (exp,env) ->
    [_,_exp_a,_exp_b] = exp
    (@evalle _exp_a, env ) % (@evalle _exp_b, env )


  "push": (exp,env) ->
    [_,list,_exp] = exp
    env[list].push @evalle _exp, env
    list


  "while": (exp,env) ->
    [_,_cond,_exp] = exp
    while @evalle(_cond,env)
      @evalle _exp, env
    undefined


  "puts": (exp,env) ->
    [_,_exps...] = exp
    console.log @evalle _exp, env for _exp in _exps


alias = (a,b) -> keywords[b] = keywords[a]

alias 'fn', '->'
alias 'def','d'

module.exports = keywords

module.exports = keywords
