src = """
( begin 
  ( def foo ( x ) ( + x 5 ) )
  ( foo 4 )
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
      current = []
      tree.push current
    else if tok == CLOSE_PAREN
      current = stack.pop()
    else
      current.push tok


  #console.log tree

  console.log JSON.stringify tree, null, 2

  tree[0]











evalle = (exp,env={}) ->
  switch exp[0]
    when "begin"
      console.log "mos def"












program = parse src
evalle program

