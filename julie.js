// Generated by CoffeeScript 1.4.0
/*

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
*/

var CLOSE_PAREN, DEF, Node, OPEN_PAREN, defs, functions, parse, program, run, src;

src = "( def foo ( x ) ( + x 5 ) )\n( foo 4 )";

OPEN_PAREN = "(";

CLOSE_PAREN = ")";

Node = (function() {

  function Node(str, parent) {
    this.str = str;
    this.parent = parent;
    this.branches = [];
  }

  return Node;

})();

parse = function(str) {
  var branch, current_branch, debride, tok, toks, tree, _i, _len;
  toks = src.split(/[\s\n]+/);
  tree = new Node("root", null);
  current_branch = tree;
  for (_i = 0, _len = toks.length; _i < _len; _i++) {
    tok = toks[_i];
    switch (tok) {
      case OPEN_PAREN:
        branch = new Node(tok, current_branch);
        current_branch.branches.push(branch);
        current_branch = branch;
        break;
      case CLOSE_PAREN:
        current_branch = current_branch.parent;
        break;
      default:
        current_branch.branches.push(new Node(tok, current_branch));
    }
  }
  debride = function(b) {
    var c, _j, _len1, _ref, _results;
    delete b.parent;
    _ref = b.branches;
    _results = [];
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      c = _ref[_j];
      _results.push(debride(c));
    }
    return _results;
  };
  debride(tree);
  console.log(toks);
  console.log(JSON.stringify(tree, null, 2));
  return tree;
};

program = parse(src);

defs = {};

DEF = function(name, fn) {
  return defs[name] = fn;
};

DEF("def", function() {});

DEF("root", function() {
  return console.log(arguments);
});

functions = {
  root: function() {},
  def: function() {}
};

run = function(p) {
  var branch, fn, _i, _len, _ref, _results;
  _ref = p.branches;
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    branch = _ref[_i];
    console.log(branch.branches);
    fn = branch.branches[0];
    console.log("fn", fn.str);
    _results.push(defs[fn.str].call({}, branch.branches.slice(1).map(function(b) {
      return b.str;
    })));
  }
  return _results;
};

run(program);
