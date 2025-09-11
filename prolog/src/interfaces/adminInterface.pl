:- use_module(library(strings)).
:- ensure_loaded('../dados.pl').
:- ensure_loaded('../repository/save.pl').
:- ensure_loaded('../repository/utils-classroom.pl').
:- ensure_loaded('../repository/utilsClass.pl').
:- ensure_loaded('../validacao.pl').
:- ensure_loaded('../schedule.pl').
:- ensure_loaded('../main.pl').
:- ensure_loaded('userInterface.pl').
:- encoding(utf8).

admin_menu :-
    nl, write('ADMINISTRADOR'), nl,
    write('1. Gerar alocação'), nl,
    write('2. Visualizar Alocações'), nl,
    write('3. Cadastrar Sala'), nl,
    write('4. Cadastrar Turma'), nl,
    write('5. Editar Sala'), nl,
    write('6. Editar Turma'), nl,
    write('7. Sair e salvar'), nl,
    write('Opção: '), 
    read_line_to_string(user_input, Opcao), nl,
    processar_opcao(Opcao).

processar_opcao("1") :- write('Gerando alocacao...'), nl, admin_menu.
processar_opcao("2") :- 
    write('Visualizando alocações...'), nl,
    write('Pressione enter para sair.'),
    read_line_to_string(user_input, n), 
    admin_menu.
processar_opcao("3") :- entry_classroom, nl, admin_menu.
processar_opcao("4") :- entry_class, nl, admin_menu.
processar_opcao("5") :- write('Editar sala...'), nl, admin_menu.
processar_opcao("6") :- submenu_turma, nl, admin_menu.
processar_opcao("7") :- write('Voltando a tela inicial...'), nl, user_screen.
processar_opcao(_) :- write('Opcao invalida!'), nl, admin_menu.

submenu_turma :-
    write('1. Editar Horarios'), nl,
    write('2. Editar requisitos'), nl,
    write('3. Realocar novo professor'), nl,
    write('4. Editar quantidade de alunos'), nl,
    write('5. Remover turma'), nl,
    write('6. Voltar'), nl,
    write('Opcao: '),
    read_line_to_string(user_input, Opcao),
    processar_submenu_turma(Opcao).

processar_submenu_turma("1") :- write('Editando horarios...'), nl,
    write('ID da turma: '), read_line_to_string(user_input, ID), nl,
    edit_schedule(ID),
    nl, submenu_turma.
processar_submenu_turma("2") :- write('Editando requisitos...'),
    write('ID da turma: '), read_line_to_string(user_input, ID), nl,
    read_recursos([],Recursos),
    altera_requisitos_class(ID, Recursos),
    nl, submenu_turma.
processar_submenu_turma("3") :- 
    write('ID da turma: '), read_line_to_string(user_input, ID),
    write('ID do novo professor: ') , read_line_to_string(user_input, Prof),
    realoca_prof(ID, Prof), 
    submenu_turma.
processar_submenu_turma("4") :- 
    write('ID da turma: '), read_line_to_string(user_input, ID),
    write('Quantidade de alunos: '), read_line_to_string(user_input, Qtde),
    altera_quantidade(ID, Qtde),
    nl, submenu_turma.
processar_submenu_turma("5") :- 
    write('ID da turma: '), read_line_to_string(user_input, ID),
    remove_class(ID), nl, submenu_turma.
processar_submenu_turma("6") :- write('Voltando ao menu anterior...'), nl, admin_menu.
processar_submenu_turma(_) :- write('Opcao invalida!'), nl, submenu_turma.
