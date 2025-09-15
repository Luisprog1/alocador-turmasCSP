:- encoding(utf8).
:- use_module(library(ansi_term)).

print_colorido(Msg, Cor) :-
    ansi_format([fg(Cor)], "~w", [Msg]).

pause :-
    print_colorido("Pressione ENTER para continuar...", yellow),
    read_line_to_string(user_input, _).

print_erro(Msg) :-
    print_colorido(Msg, red).

print_sucesso(Msg) :-
    print_colorido(Msg, green).

visualizar_turmas :-
    findall((ID,Nome,ProfID),
        class(ID, Nome, _, ProfID, _, _),
        Turmas),
    (   Turmas = [] ->
        print_erro("Nenhuma turma cadastrada."), nl
    ;   forall(member((ID,Nome,ProfID), Turmas),
            print_turma(ID,Nome,ProfID))
    ).

print_turma(ID, Nome, ProfID) :-
    print_colorido([ID], white),
    write(": "),
    print_colorido(Nome, green),
    write(" - Professor: "),
    print_colorido(ProfID, green),
    nl.

visualizar_turmas(ProfID) :-
    findall((ID,Nome,Curso,Vagas,Recursos),
        class(ID, Nome, Curso, ProfID, Vagas, Recursos),
        Turmas),
    (   Turmas = [] ->
        print_erro("Você não possui turmas cadastradas."), nl
    ;   forall(member((ID,Nome,Curso,Vagas,Recursos), Turmas),
            print_turma_prof(ID,Nome,Curso,Vagas,Recursos))
    ).

print_turma_prof(ID, Nome, Curso, Vagas, Recursos) :-
    print_colorido([ID], cyan),
    write(": "),
    print_colorido(Nome, green),
    write(" - "),
    print_colorido(Curso, green),
    write(" | Vagas: "),
    print_colorido(Vagas, green),
    nl,
    write("Recursos: "),
    print_colorido(Recursos, green),
    nl, nl.

visualizar_salas :-
    findall((ID, Nome, Capacidade, Recursos),
        classroom(ID, Nome, Capacidade, Recursos),
        Salas),
    (   Salas = [] ->
        print_erro("Nenhuma sala cadastrada."), nl
    ;   forall(member((ID, Nome, Capacidade, Recursos), Salas),
            print_sala(ID, Nome, Capacidade, Recursos))
    ).

print_sala(ID, Nome, Capacidade, Recursos) :-
    print_colorido(ID, white),
    write(": "),
    print_colorido(Nome, green),
    write(" | Capacidade: "),
    print_colorido(Capacidade, green),
    write(" | Recursos: "),
    print_colorido(Recursos, green),
    nl.

