:- dynamic alocacao/3. 
:- dynamic horario_ocupado/3.
:- ensure_loaded('repository/save.pl').
:- consult('rules/classes.pl').
:- consult('rules/classrooms.pl').
:- consult('rules/horarios_turmas.pl').
:- consult('rules/horarios_salas.pl').

alocar_tudo :-

    retractall(alocacao(_, _, _, _)),
    findall(T, horario_turma(T, _, _), TurmasComDuplicatas),
    sort(TurmasComDuplicatas, TurmasParaAlocar),
    alocar_recursivo(TurmasParaAlocar, []),
    exibir_resultado,
    save_alocacoes('rules/alocacoes.pl'),
    !. 

alocar_tudo :-
    write('As salas disponiveis nao atendem aos requisitos de todas as turmas.'), nl.

alocar_recursivo([], AlocacoesFinais) :-
    gravar_alocacoes(AlocacoesFinais).

alocar_recursivo([IdTurma|OutrasTurmas], AlocacoesAtuais) :-
    findall(horario(Dia, Horario), horario_turma(IdTurma, Dia, Horario), HorariosDaTurma),
    classroom(IdSala, _, CapacidadeSala, RecursosSala),
    class(IdTurma, _, _, _, CapacidadeTurma, RequisitosTurma),
    CapacidadeSala >= CapacidadeTurma,
    subset(RequisitosTurma, RecursosSala),
    \+ conflito_de_horario(IdSala, HorariosDaTurma, AlocacoesAtuais),
    unir_alocacoes(IdTurma, IdSala, HorariosDaTurma, AlocacoesAtuais, NovasAlocacoes),
    alocar_recursivo(OutrasTurmas, NovasAlocacoes).

conflito_de_horario(IdSala, [horario(Dia, Horario)|_], AlocacoesAtuais) :-
    member(alocacao(_, IdSala, Dia, Horario), AlocacoesAtuais),
    !.

conflito_de_horario(IdSala, [_|RestoHorarios], AlocacoesAtuais) :-
    conflito_de_horario(IdSala, RestoHorarios, AlocacoesAtuais).

unir_alocacoes(IdTurma, IdSala, HorariosDaTurma, AlocacoesAtuais, NovasAlocacoes) :-
    findall(alocacao(IdTurma, IdSala, Dia, Horario), member(horario(Dia, Horario), HorariosDaTurma), AlocacoesNovas),
    append(AlocacoesNovas, AlocacoesAtuais, NovasAlocacoes).

subset([], _).
subset([X|Xs], Y) :-
    member(X, Y),
    subset(Xs, Y).

gravar_alocacoes([]) :- !.
gravar_alocacoes([alocacao(T, S, D, H)|Resto]) :-
    assertz(alocacao(T, S, D, H)),
    gravar_alocacoes(Resto).

exibir_resultado :-
    write('Todas as turmas foram alocadas com sucesso.'), nl,
    findall(alocacao(T, S, D, H), alocacao(T, S, D, H), ListaFinal),
    write('Alocacoes: '), write(ListaFinal), nl,
    fail.
exibir_resultado.