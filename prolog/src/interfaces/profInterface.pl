:- use_module(library(strings)).
:- ensure_loaded('../dados.pl').
:- ensure_loaded('../repository/save.pl').
:- ensure_loaded('../repository/utilsClass.pl').
:- ensure_loaded('../validacao.pl').
:- ensure_loaded('../main.pl').
:- ensure_loaded('userInterface.pl').
:- ensure_loaded('UI.pl').
:- encoding(utf8).

professor_menu :-
    draw_header("PROFESSOR"),
    write('1. Visualizar turmas'), nl,
    write('2. Alterar requisitos da turma'), nl,
    write('3. Sair'), nl,
    write('Opção: '),
    read_line_to_string(user_input, Opcao),
    professor_op(Opcao).

% Tratamento das opções
professor_op("1") :-
    write('Visualizar turmas'), nl.
professor_op("2") :-
    write('Alterar requisitos da turma'), nl,
    write("ID da turma: "), read_line_to_string(user_input, ID),
    read_recursos([],Recursos),
    altera_requisitos_class(ID, Recursos), professor_menu.
professor_op("3") :-
    write('Saindo...'), nl, user_screen.
professor_op(_) :-
    write('Opção inválida! Tente novamente.'), nl,
    professor_menu.
