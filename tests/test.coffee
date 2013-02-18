assert = require 'assert'
julie = require '../julie'

run = (src) ->
  program = julie.parse src
  vm = julie.vm()
  vm.evalle program


suite "something", ->


  test "function definition", ->
    assert.equal 15, run """
      ( begin
        ( fun foo ( x ) ( + x 5 ) )
        ( foo 10 )
      )
      """


  test "if", ->
    assert.equal 1, run """
      ( if 1 
        1
        2
      )
      """
    assert.equal 2, run """
      ( if 0 
        1
        2
      )
      """


  test "while", ->
    assert.deepEqual [1,2,3,4,5], run """
      ( begin
        ( def results [] )
        ( def i 1 )
        ( while ( < i 6 ) 
          ( begin
            ( push results i )
            ( def i ( + i 1 ) )
          )
        )
        ( results )
      )
      """


suite "random e2e stuff", ->


  test "primes", -> # do more actual tests here
    assert.equal 97, run("""
      ( begin 
        ( def i 3 )
        ( def results [] )
        ( while ( < i 100 ) 
          ( begin
            ( def d 2 )
            ( def isprime 1 )
            ( while ( < d i ) 
              ( begin 
                ( def remainder ( % i d ) )
                ( if ( = 0 remainder )
                  ( begin
                    ( def isprime 0 )
                    ( def d i )
                  )
                  ( 0 )
                )
                ( def d ( + d 1 ) )
              )
            )
            ( if isprime 
              ( push results i )
              ( 0 )
            )
            ( def i ( + i 1 ) )
          )
        )
        ( results )
      )
      """)[23]


