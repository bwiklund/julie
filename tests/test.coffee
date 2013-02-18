assert = require 'assert'

julie = require '../julie'

foo = -> 5

suite "something", ->
  
  test "function definition", ->
    assert.equal 15, julie """
      ( begin
        ( fun foo ( x ) ( + x 5 ) )
        ( foo 10 )
      )
      """