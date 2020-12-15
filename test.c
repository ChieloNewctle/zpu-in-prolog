int subtract(int a, int b) {
    return a - b;
}

int fib_r(int k) {
    if(k <= 0)
        return 0;
    if(k <= 1)
        return 1;
    return fib_r(k - 2) + fib_r(k - 1);
}

int fib_i(int n) {
    int i, u = 0, v = 1;
    for(i = 0; i < n; ++i) {
        int w = u + v;
        u = v;
        v = w;
    }
    return u;
}

int assert_fib(int n) {
    return fib_r(n) == fib_i(n);
}

int branching(int n) {
    return n <= 3 ? 391 : 1096;
}

int dist(int x1, int y1, int x2, int y2) {
    int dx = x1 - x2;
    int dy = y1 - y2;
    return dx * dx + dy * dy;
}

int binary_xor_i(int x, int y) {
    if(x < 0 || y < 0)
        return -1;
    int z = 0, i, j;
    x %= 2147483647;
    y %= 2147483647;
    for(i = 0, j = 1; i < 31; ++i, j *= 2, x >>= 1, y >>= 1) {
        if((x & 1) != (y & 1))
            z |= j;
    }
    return z;
}
