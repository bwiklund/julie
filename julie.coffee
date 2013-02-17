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
      for e in exp[1..]
        ret = evalle e
      return ret
    else
      "foo"












program = parse src
console.log JSON.stringify program, null, 2

console.log evalle program

