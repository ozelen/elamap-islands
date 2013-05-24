# Implementation of the Park Miller (1988) "minimal standard" linear
# congruential pseudo-random number generator.
#
# For a full explanation visit: http://www.firstpr.com.au/dsp/rand31/
#
# The generator uses a modulus constant (m) of 2^31 - 1 which is a
# Mersenne Prime number and a full-period-multiplier of 16807.
# Output is a 31 bit unsigned integer. The range of values output is
# 1 to 2,147,483,646 (2^31-1) and the seed must be in this range too.
#
# David G. Carta's optimisation which needs only 32 bit integer math,
# and no division is actually *slower* in flash (both AS2 & AS3) so
# it's better to use the double-precision floating point version.
#
# Ported to CoffeeScript by Oleksiy Zelenyuk
# using source code of Michael Baczynski, www.polygonal.de

class ELA.math.NumGen
  seed : null

  constructor: () ->
    this.seed = 1

  #  set seed with a 31 bit unsigned integer
  #  between 1 and 0X7FFFFFFE inclusive. don't use 0!
  next_int : ->
    this.gen()

  # provides the next pseudorandom number
  # as a float between nearly 0 and nearly 1.0.
  next_double : ->
    this.gen() / 2147483647


  # provides the next pseudorandom number
  # as an unsigned integer (31 bits)
  next_int_range : (min, max) ->
    min -= 0.4999
    max += 0.4999
    Math.round(min + ((max - min) * nextDouble()))

  # provides the next pseudorandom number
  # as an unsigned integer (31 bits) betweeen
  # a given range.
  next_int_range : (min, max) ->
    min -= 0.4999;
    max += 0.4999;
    Math.round(min + ((max - min) * this.nextDouble()));

  # provides the next pseudorandom number
  # as a float between a given range.
  next_double_range : (min, max) ->
    min + ((max - min) * this.nextDouble());

  # generator:
  # new-value = (old-value * 16807) mod (2^31 - 1)
  gen : () ->
    #integer version 1, for max int 2^46 - 1 or larger.
    this.seed = (this.seed * 16807) % 2147483647;