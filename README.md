# ZPU in Prolog

This is a small toy to run [ZPU](https://github.com/zylin/zpu) assembly code in [SWI-Prolog](https://www.swi-prolog.org).

The gcc toolchians for ZPU can be found in [zylin/zpugcc](https://github.com/zylin/zpugcc).

`zpu.pl` defines the core predicates about ZPU states.

`toprolog.py` translates ZPU assembly code into predicates adapted to the `zpu` module.

## Example

With `test.pl`, you can ask about the result(s) of a function in `test.c`.

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
