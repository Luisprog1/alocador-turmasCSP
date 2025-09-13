:- use_module(library(strings)).
:- ensure_loaded('../dados.pl').
:- ensure_loaded('../repository/save.pl').
:- ensure_loaded('../repository/utilsClass.pl').
:- ensure_loaded('../validacao.pl').
:- ensure_loaded('../main.pl').
:- ensure_loaded('userInterface.pl').
:- ensure_loaded('UI.pl').
:- ensure_loaded('../rules/classes.pl').
:- ensure_loaded('../repository/utils.pl').
:- encoding(utf8).
:- use_module(library(ansi_term)).

professor_menu(ID) :-
    draw_header("PROFESSOR"),
    write('1. Visualizar turmas'), nl,
    write('2. Alterar requisitos da turma'), nl,
    write('3. Sair'), nl,
    write('Opção: '),
    read_line_to_string(user_input, Opcao),
    professor_op(Opcao, ID).

% Tratamento das opções
professor_op("1", ID) :-
    visualizar_turmas(ID),
    professor_menu(ID).

professor_op("2", ID) :-
    write("ID da turma: "), read_line_to_string(user_input, ClassID),
    read_recursos([], Recursos),
    altera_requisitos_class(ClassID, Recursos),
    professor_menu(ID).

professor_op("3", _) :-
    write('Saindo...'), nl,
    user_screen.

professor_op(_, ID) :-
    print_erro('Opção inválida! Tente novamente.'), nl,
    pause,
    professor_menu(ID).

visualizar_turmas(ProfID) :-
    findall((ID,Nome,Curso,Vagas,Recursos),
        class(ID, Nome, Curso, ProfID, Vagas, Recursos),
        Turmas),
    (   Turmas = [] ->
        print_erro("Você não possui turmas cadastradas."), nl
    ;   forall(member((ID,Nome,Curso,Vagas,Recursos), Turmas),
            print_turma(ID,Nome,Curso,Vagas,Recursos))
    ),
    pause.

print_turma(ID, Nome, Curso, Vagas, Recursos) :-
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
