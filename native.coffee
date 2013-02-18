primes = []
for i in [3...200000]
  isprime = true
  for d in [3...i]
    if i%d == 0
      isprime = false
      break
  #console.log i if isprime