###

stuff in lisp


() nesting

()
  define
  foo
  ()
    lambda
    ()
      x
    ()
      +
      x
      5

###

src = """
( def foo ( x ) ( + x 5 ) )
( foo 4 )
"""





OPEN_PAREN = "("
CLOSE_PAREN = ")"


parse = (str) ->

  toks = src.split /[\s\n]+/

  # tree = new Node("root",null)
  # current_branch = tree

  # for tok in toks
  #   switch tok
  #     when OPEN_PAREN 
  #       branch = new Node tok, current_branch
  #       current_branch.branches.push branch
  #       current_branch = branch
  #     when CLOSE_PAREN
  #       current_branch = current_branch.parent
  #     else
  #       current_branch.branches.push new Node tok, current_branch

  # debride = (b) -> delete b.parent; debride c for c in b.branches
  # debride tree

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

  tree





program = parse src


defs = {}
DEF = (name,fn) -> defs[name] = fn


DEF "def", (fnName,args,fn) ->
  argNames = args.branches.map (b) -> b.str
  console.log argNames

  DEF fnName.str, ->
    args = {}
    for v,i in arguments
      args[argNames[i]] = parseFloat v.str
    console.log args





functions =
  root: ->
  def:  ->


run = (p) ->
  for branch in p.branches
    fn = branch.branches[0]
    defs[fn.str].apply {}, branch.branches[1..]






run program