update_capacity(ID,Capacidade):-
    classroom(ID, Bloco, oldCapacity, Recursos),
    format('A Antiga capacidade : ~w~n',[oldCapacity])
    retract(classroom(ID,_, _, _)),
    assertz(classroom(ID,Bloco, Capacidade, Recursos))
    save_classrooms('../rules/classrooms.pl')