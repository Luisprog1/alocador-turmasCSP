:- dynamic(class/6).
:- ensure_loaded('save.pl').
:- ensure_loaded('interfaces/adminInterface.pl').
:- consult('rules/classes.pl').
:- consult('rules/users.pl').
:- encoding(utf8).

realoca_prof(IdTurma, IdProf) :- 
    (class(IdTurma, Disciplina, Curso, _, Capacidade, Requisitos) -> true; 
    write('Turma não encontrada!'), nl, submenu_turma
    ),
    (user(IdProf, _,_,_) -> true;
    write("Professor não encontrado!"), nl, submenu_turma
    ),
    retract(class(IdTurma,_,_,_,_,_)),
    assertz(class(IdTurma, Disciplina, Curso, IdProf, Capacidade, Requisitos)),
    save_classes('rules/classes.pl').
