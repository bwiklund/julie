primes = []
for( var i = 3; i < 200000; i++ ){
  var isprime = true
  for( var d = 2; d < i; d++ ){
    if( i%d == 0 ){
      isprime = false;
      break;
    }
  }
  //if( isprime ){
  //  console.log( i );
  //}
}