# ZPU in Prolog

A small toy to run ZPU assembly code in Prolog.

`zpu.pl` defines the core predicates about ZPU states.

`toprolog.py` translates ZPU assembly code into predicates fitting the `zpu` module.

## Example

You can ask about the result(s) of a function.

```prolog
?- result(fib_r, [10], R).
R = 55 ;
false.

?- result(fib_i, [10], R).
R = 55 ;
false.

?- A is 2 ^ 128, result(dist, [-A, -A, A, A], R).
A = 340282366920938463463374607431768211456,
R = 926336713898529563388567880069503262826159877325124512315660672063305037119488 ;
false.
```
