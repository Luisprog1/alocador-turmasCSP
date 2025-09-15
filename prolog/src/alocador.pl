:- dynamic alocacao/4. 
:- dynamic horario_ocupado/3.
:- ensure_loaded('repository/save.pl').
:- consult('rules/classes.pl').
:- consult('rules/classrooms.pl').
:- consult('rules/horarios_turmas.pl').
:- consult('rules/alocacoes.pl').
:- ensure_loaded('interfaces/UI.pl').

alocar_tudo :-

    retractall(alocacao(_, _, _, _)),
    findall(T, horario_turma(T, _, _), TurmasComDuplicatas),
    sort(TurmasComDuplicatas, TurmasParaAlocar),
    alocar_recursivo(TurmasParaAlocar, []),
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
    findall(alocacao(T, S, D, H), alocacao(T, S, D, H), ListaFinal),
    write('Alocacoes:'), nl,
    imprimir_lista_alocacoes(ListaFinal),
    fail.

exibir_resultado.

imprimir_lista_alocacoes([]) :- !.
imprimir_lista_alocacoes([alocacao(Turma, Sala, Dia, Hora)|Resto]) :-
    print_colorido("Turma ", yellow),
    print_colorido(Turma, green),
    write(" | "),
    print_colorido("Sala ", yellow),
    print_colorido(Sala, green),
    write(" | "),
    print_colorido("Dia: ", yellow),
    print_colorido(Dia, green),
    write(" | "),
    print_colorido("Horário: ", yellow),
    print_colorido(Hora, green),
    nl,
    imprimir_lista_alocacoes(Resto).