assert = require 'assert'

julie = require '../julie'


suite "something", ->

  test "function definition", ->
    assert.equal 15, julie """
      ( begin
        ( fun foo ( x ) ( + x 5 ) )
        ( foo 10 )
      )
      """

  test "while", ->
    assert.deepEqual [1,2,3,4,5], julie """
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
    assert.equal 97, julie("""
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