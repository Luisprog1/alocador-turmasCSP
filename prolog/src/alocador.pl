:- dynamic horario_ocupado/3.
:- consult('rules/classes.pl').
:- consult('rules/classrooms.pl').
:- consult('rules/horarios_turmas.pl').

pode_alocar(IdTurma, IdSala) :-
    class(IdTurma, _, _, _, Qtd, Requisitos),
    classroom(IdSala, _, Capacidade, Recursos),
    Capacidade >= Qtd,
    horarios_compativeis(IdTurma, IdSala),
    subset(Requisitos, Recursos).

horarios_compativeis(IdTurma, IdSala) :-
    forall(
        horario_turma(IdTurma, Dia, Horario),
        \+horario_ocupado(IdSala, Dia, Horario)
    ).

