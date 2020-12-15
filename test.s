	.file	"test.c"
.text
	.globl	subtract
	.type	subtract, @function
subtract:
	loadsp 4
	loadsp 12
	sub
	im _memreg+0
	store
	poppc
	.size	subtract, .-subtract
	.globl	fib_r
	.type	fib_r, @function
fib_r:
	im -2
	pushspadd
	popsp
	loadsp 16
	storesp 12
	im 0
	storesp 8
	loadsp 4
	loadsp 12
	lessthanorequal
	impcrel .L2
	neqbranch
	im 1
	storesp 8
	loadsp 4
	loadsp 12
	lessthanorequal
	impcrel .L2
	neqbranch
	im -2
	addsp 12
	storesp 4
	impcrel (fib_r)
	callpcrel
	im _memreg+0
	load
	im -1
	addsp 16
	storesp 8
	storesp 8
	impcrel (fib_r)
	callpcrel
	im _memreg+0
	load
	addsp 8
	storesp 8
.L2:
	loadsp 4
	im _memreg+0
	store
	im 4
	pushspadd
	popsp
	poppc
	.size	fib_r, .-fib_r
	.globl	fib_i
	.type	fib_i, @function
fib_i:
	im -3
	pushspadd
	popsp
	loadsp 20
	storesp 4
	im 0
	storesp 16
	im 1
	storesp 12
	loadsp 12
	loadsp 4
	lessthanorequal
	impcrel .L13
	neqbranch
	loadsp 0
	storesp 8
.L11:
	loadsp 8
	addsp 16
	loadsp 12
	storesp 20
	im -1
	addsp 12
	storesp 12
	storesp 12
	loadsp 4
	impcrel .L11
	neqbranch
.L13:
	loadsp 12
	im _memreg+0
	store
	im 5
	pushspadd
	popsp
	poppc
	.size	fib_i, .-fib_i
	.globl	assert_fib
	.type	assert_fib, @function
assert_fib:
	im -3
	pushspadd
	popsp
	loadsp 20
	storesp 12
	im 0
	loadsp 12
	storesp 8
	storesp 16
	impcrel (fib_r)
	callpcrel
	im _memreg+0
	load
	loadsp 12
	storesp 8
	storesp 8
	impcrel (fib_i)
	callpcrel
	loadsp 4
	im _memreg+0
	load
	eq
	impcrel .L18
	neqbranch
	loadsp 12
	im _memreg+0
	store
	im 5
	pushspadd
	popsp
	poppc
.L18:
	im 1
	nop
	im _memreg+0
	store
	im 5
	pushspadd
	popsp
	poppc
	.size	assert_fib, .-assert_fib
	.globl	branching
	.type	branching, @function
branching:
	im 0
	pushspadd
	popsp
	im 391
	storesp 4
	im 3
	loadsp 12
	lessthanorequal
	impcrel .L21
	neqbranch
	im 1096
	storesp 4
.L21:
	loadsp 0
	im _memreg+0
	store
	im 2
	pushspadd
	popsp
	poppc
	.size	branching, .-branching
	.globl	__mulsi3
	.globl	dist
	.type	dist, @function
dist:
	im -3
	pushspadd
	popsp
	loadsp 20
	loadsp 32
	sub
	loadsp 24
	loadsp 36
	sub
	mult
	loadsp 28
	loadsp 40
	sub
	loadsp 32
	loadsp 44
	sub
	mult
	storesp 16
	loadsp 12
	add
	im _memreg+0
	store
	im 5
	pushspadd
	popsp
	poppc
	.size	dist, .-dist
	.globl	__modsi3
	.globl	binary_xor_i
	.type	binary_xor_i, @function
binary_xor_i:
	im -8
	pushspadd
	popsp
	loadsp 40
	loadsp 48
	im 0
	loadsp 8
	lessthan
	im 0
	loadsp 8
	lessthan
	or
	storesp 20
	storesp 24
	storesp 28
	im -1
	storesp 16
	loadsp 8
	impcrel .L24
	neqbranch
	loadsp 8
	im 2147483647
	loadsp 32
	mod
	im 2147483647
	loadsp 28
	mod
	storesp 28
	storesp 32
	storesp 36
	im 1
	storesp 24
	im 30
	storesp 32
.L32:
	loadsp 24
	im 1
	and
	loadsp 20
	im 1
	and
	storesp 16
	storesp 16
	loadsp 12
	loadsp 12
	eq
	impcrel .L30
	neqbranch
	loadsp 32
	loadsp 24
	or
	storesp 36
.L30:
	im -1
	addsp 32
	loadsp 24
	addsp 28
	loadsp 32
	im 1
	ashiftright
	loadsp 28
	im 1
	ashiftright
	storesp 32
	storesp 36
	storesp 28
	storesp 32
	loadsp 28
	im 0
	lessthanorequal
	impcrel .L32
	neqbranch
	loadsp 32
	storesp 16
.L24:
	loadsp 12
	im _memreg+0
	store
	im 10
	pushspadd
	popsp
	poppc
	.size	binary_xor_i, .-binary_xor_i
	.ident	"GCC: (GNU) 3.4.2"
