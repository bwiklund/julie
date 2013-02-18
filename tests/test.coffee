assert = require 'assert'

foo = -> 5

suite "something", ->
  test "foo", ->
    assert.equal 5, foo()