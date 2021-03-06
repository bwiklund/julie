# coffeescript -> js -> node v8 -> julie src -> julie vm

assert = require 'assert'
julie = require '../julie'


run = (src) ->
  program = julie.parse src
  vm = julie.vm()
  vm.evalle program


runWhitespace = (src) ->
  program = julie.parseWhitespace src
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





suite "whitespace sensitive dialect", ->


  test "hello world", ->
    assert.deepEqual ['begin',['+','1','2']], julie.parseWhitespace """
      begin
        + 1 2
      """


  test "double unindent", ->
    assert.deepEqual ['begin',['foo',['bar',['+','1','2']]],['baz','1','2']], julie.parseWhitespace """
      begin
        foo
          bar
            + 1 2
        baz 1 2
      """


  test "prime", ->
    assert.equal 97, runWhitespace("""
      begin
        def i 3
        def results []
        while
          < i 100
          begin
            def d 2
            def isprime 1
            while
              < d i
              begin
                def remainder
                  % i d
                if
                  = 0 remainder
                  begin
                    def isprime 0
                    def d i
                  0
                def d
                  + d 1
            if isprime
              push results i
              0
            def i
              + i 1
        results
      """)[23]


  test "nicerprime", ->
    assert.equal 97, runWhitespace("""
      begin

        def results []

        fun testPrime
          n
          begin
            def denom 2
            def isPrime 1
            while
              < denom n
              begin
                def remainder
                  % n denom
                if
                  = 0 remainder
                  begin
                    def isPrime 0
                    def denom n
                  0
                def denom
                  + denom 1
            isPrime

        def i 3
        while
          < i 100
          begin
            if
              testPrime i
              push results i
              0
            def i
              + i 1
        results

      """)[23]


  test "fibonacci", ->
    assert.deepEqual [1,1,2,3,5,8,13,21,34,55], runWhitespace """
      begin
        def a 1
        def b 1
        def results []
        push results a
        push results b
        while
          < b 55
          begin
            def c
              + a b
            def a b
            def b c
            push results c
        results
    """


  test "ignore trailing whitespace", ->
    assert.equal 10, runWhitespace """
      begin
        + 5 5 """


  test "ignore various types of empty lines lines", ->
    assert.equal 10, runWhitespace """
      begin
        def f 10

        f
      """
    assert.equal 10, runWhitespace """
      begin
        def f 10
  
        f
      """
    assert.equal 10, runWhitespace """
      begin
        def f 10
        
        f
      """
    assert.equal 10, runWhitespace """
      begin
        def f 10
          
        f
      """