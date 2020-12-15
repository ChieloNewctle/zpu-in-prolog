import sys
from collections import defaultdict


def parse_ins(line):
    ins, *args = line.strip().split()
    if not ins.startswith('.'):
        return (ins.lower(), *args)
    return None


def compress_return(code):
    res = []
    cur = 0
    while cur < len(code):
        ins, *args = code[cur]
        if ins == 'im':
            assert len(args) == 1
            arg = args[0]
            if arg.startswith('_memreg'):
                assert arg == '_memreg+0'
                assert cur + 1 < len(code)
                next_code = code[cur + 1]
                assert next_code in (('store',), ('load',))
                next_ins = next_code[0]
                res.append((f'{next_ins}ret',))
                res.append(('nop',))
                cur += 2
                continue
        res.append((ins, *args))
        cur += 1
    return res


def realize_label(code, labels):
    label_addr = dict()
    for i, label in enumerate(labels):
        for j in label:
            label_addr[j] = i
    res = []
    for i, (ins, *args) in enumerate(code):
        if ins == 'impcrel':
            assert len(args) == 1
            arg = args[0]
            if arg[0] == '(' and arg[-1] == ')':
                arg = arg[1:-1]
            res.append(('im', str(label_addr[arg])))
        elif ins == 'callpcrel':
            assert i > 0 and code[i - 1][0] == 'impcrel'
            res.append(('call',))
        else:
            res.append((ins, *args))
    return res, label_addr


def normalize(code):
    res = []
    for ins, *args in code:
        assert len(args) in (0, 1)
        if len(args) == 1:
            arg = args[0]
            assert arg.isdecimal() \
                or ((arg.startswith('-') or arg.startswith('+')) \
                    and arg[1:].isdecimal())
            arg = int(arg)
            if ins in ('storesp', 'loadsp', 'addsp'):
                assert arg % 4 == 0
                res.append((ins, arg // 4))
            else:
                res.append((ins, arg))
        else:
            res.append((ins,))
    return res


def parse_file(f):
    code, labels = [], [list()]
    for line in f.readlines():
        if line.startswith('\t'):
            ins = parse_ins(line)
            if ins:
                code.append(ins)
                labels.append(list())
        else:
            line = line.strip()
            if line.endswith(':'):
                labels[-1].append(line[:-1])
    code, label_addr = realize_label(code, labels)
    code = compress_return(code)
    code = normalize(code)
    return code, label_addr


def to_prolog(code, label_addr):
    labels = defaultdict(list)
    for k, v in label_addr.items():
        labels[v].append(k)
    print(':- use_module(zpu).', end='\n\n')
    for k, v in label_addr.items():
        print('func_entry({}, {}).'.format(repr(k), v))
    print()
    for i in range(len(code)):
        if i in labels:
            print('/* {} */'.format(', '.join(map(str, labels[i]))))
        ins = code[i] + ('_',)
        ins = ins[:2]
        print('instruction({}, {}, {}).'.format(i, *ins))


def main():
    assert len(sys.argv) in (1, 2)
    if len(sys.argv) == 2:
        with open(sys.argv[1]) as f:
            code, label_addr = parse_file(f)
    else:
        code, label_addr = parse_file(sys.stdin)
    to_prolog(code, label_addr)


if __name__ == '__main__':
    main()
