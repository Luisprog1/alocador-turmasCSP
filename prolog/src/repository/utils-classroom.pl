:- dynamic(classroom/4).

update_capacity(ID, Capacidade) :-

    classroom(ID, Bloco, _, Recursos),
    retract(classroom(ID, _, _, _)),
    assertz(classroom(ID, Bloco, Capacidade, Recursos)),
    save_classrooms('rules/classrooms.pl').