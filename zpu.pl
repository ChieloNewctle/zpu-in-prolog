:- module(zpu, [zpu_states/1, has_final_state/6, result/3]).


zpu_states([[PC, RET, STK]]):-
    integer(PC), PC >= -1,
    final_state(PC, RET, STK).

zpu_states([[PC, RET, STK]|T]):-
    integer(PC), PC >= -1,
    next_state(PC, RET, STK, PC_, RET_, STK_),
    append([[PC_, RET_, STK_]], _, T),
    zpu_states(T).
/*
zpu_states(S):-
    length(S, S_L),
    forall(nth1(I, S, [PC, RET, STK]), (integer(PC), PC >= -1, (
        (I == S_L, final_state(PC, RET, STK));
        (I < S_L, J is I + 1, nth1(J, S, [PC_, RET_, STK_]), next_state(PC, RET, STK, PC_, RET_, STK_))
    ))).
*/

has_final_state(PC, RET, STK, PC_, RET_, STK_):-
    zpu_states([[PC, RET, STK]|S]),
    last(S, [PC_, RET_, STK_]).


result(EntryPC, Arg, Ret):-
    append([-1], Arg, S),
    has_final_state(EntryPC, nil, S, _, Ret, _).

result(EntryName, Arg, Ret):-
    func_entry(EntryName, EntryPC),
    append([-1], Arg, S),
    has_final_state(EntryPC, nil, S, _, Ret, _).


final_state(-1, RET, _):-
    integer(RET).


next_state(PC, RET, STK, PC_, RET, STK):-
    instruction(PC, 'nop', _),
    PC_ is PC + 1 .

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'im', Val),
    PC_ is PC + 1,
    append([Val], STK, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'storesp', Addr),
    PC_ is PC + 1,
    append([Val], S, STK),
    nth1(Addr, S, _, T),
    nth1(Addr, STK_, Val, T).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'loadsp', Addr),
    PC_ is PC + 1,
    nth0(Addr, STK, Val),
    append([Val], STK, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'addsp', Addr),
    PC_ is PC + 1,
    nth0(Addr, STK, Val),
    append([Top], Rest, STK),
    Top_ is Top + Val,
    append([Top_], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'pushsp', _),
    PC_ is PC + 1,
    length(STK, STK_L),
    append([sp(STK_L)], STK, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'pushspadd', _),
    PC_ is PC + 1,
    length(STK, STK_L),
    append([Val], S, STK),
    Top is STK_L - Val,
    append([sp(Top)], S, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'popsp', _),
    PC_ is PC + 1,
    append([sp(STK_L)], _, STK),
    adjudge_stack(STK, STK_L, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'neg', _),
    PC_ is PC + 1,
    append([Val], Rest, STK),
    Top is -Val,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'add', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA + TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'sub', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopB - TopA,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'mult', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA * TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'div', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA // TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'mod', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA - TopA // TopB * TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'and', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA /\ TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'or', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA \/ TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'xor', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    Top is TopA xor TopB,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'ashiftright', _),
    PC_ is PC + 1,
    append([Shift, Val], Rest, STK),
    Top is Val >> Shift,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'ashiftleft', _),
    PC_ is PC + 1,
    append([Shift, Val], Rest, STK),
    Top is Val << Shift,
    append([Top], Rest, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'eq', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    (
        TopA == TopB, append([1], Rest, STK_);
        TopA =\= TopB, append([0], Rest, STK_)
    ).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'neq', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    (
        TopA =\= TopB, append([1], Rest, STK_);
        TopA == TopB, append([0], Rest, STK_)
    ).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'lessthan', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    (
        TopA < TopB, append([1], Rest, STK_);
        TopA >= TopB, append([0], Rest, STK_)
    ).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'lessthanorequal', _),
    PC_ is PC + 1,
    append([TopA, TopB], Rest, STK),
    (
        TopA =< TopB, append([1], Rest, STK_);
        TopA > TopB, append([0], Rest, STK_)
    ).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'eqbranch', _),
    append([BR, Comp], STK_, STK),
    (
        Comp == 0, PC_ is BR;
        Comp =\= 0, PC_ is PC + 1
    ).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'neqbranch', _),
    append([BR, Comp], STK_, STK),
    (
        Comp =\= 0, PC_ is BR;
        Comp == 0, PC_ is PC + 1
    ).

next_state(PC, _, STK, PC_, RetVal, STK_):-
    instruction(PC, 'storeret', _),
    PC_ is PC + 1,
    append([RetVal], STK_, STK).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'loadret', _),
    PC_ is PC + 1,
    append([RET], STK, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'poppc', _),
    append([PC_], STK_, STK).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'poppcrel', _),
    append([Top], STK_, STK),
    PC_ is PC + Top.

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'call', _),
    append([PC_], S, STK),
    BR is PC + 1,
    append([BR], S, STK_).

next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'callpcrel', _),
    append([Top], S, STK),
    BR is PC + 1,
    append([BR], S, STK_),
    PC_ is PC + Top.


/** 
 * UwU, what is this?
 * try to change one of the branch instructions into this one!
 */
next_state(PC, RET, STK, PC_, RET, STK_):-
    instruction(PC, 'nondetbranch', _),
    append([BR, _], STK_, STK),
    (
        PC_ is BR;
        PC_ is PC + 1
    ).


adjudge_stack(STK, L, STK_):-
    length(STK, STK_L),
    (
        L = STK_L, STK_ = STK;
        L < STK_L, append([_], S, STK), adjudge_stack(S, L, STK_);
        L > STK_L, append([nil], STK, S), adjudge_stack(S, L, STK_)
    ).

