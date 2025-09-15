:- use_module(library(strings)).
:- ensure_loaded('../dados.pl').
:- ensure_loaded('../repository/save.pl').
:- ensure_loaded('../repository/utils-classroom.pl').
:- ensure_loaded('../repository/utilsClass.pl').
:- ensure_loaded('../validacao.pl').
:- ensure_loaded('../schedule.pl').
:- ensure_loaded('../main.pl').
:- ensure_loaded('userInterface.pl').
:- ensure_loaded('UI.pl').
:- ensure_loaded('../alocador.pl').
:- encoding(utf8).

admin_menu :-
    draw_header("ADMINISTRADOR"),
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

processar_opcao("1") :- alocar_tudo, nl, admin_menu.
processar_opcao("2") :- 
    exibir_resultado, nl,
    pause,
    admin_menu.
processar_opcao("3") :- entry_classroom, nl, admin_menu.
processar_opcao("4") :- entry_class, nl, admin_menu.
processar_opcao("5") :- submenu_sala, nl, admin_menu.
processar_opcao("6") :- submenu_turma, nl, admin_menu.
processar_opcao("7") :- write('Voltando a tela inicial...'), nl, user_screen.
processar_opcao(_) :- print_erro('Opcao invalida!\n'), pause, admin_menu.

submenu_sala :-
    draw_header('EDITAR SALA'), 
    write('1 - Editar os recursos da sala'), nl,
    write('2 - Editar a capacidade da sala'), nl,
    write('3 - Voltar ao menu anterior'), nl,
    write('Escolha uma opção: '),
    read_line_to_string(user_input, Opcao),
    processar_submenu_sala(Opcao).

    processar_submenu_sala("1") :-
    write('ID da sala: '), read_line_to_string(user_input, ID),
    ( classroom(ID, _, _, _) ->
        read_recursos([], Recursos),
        altera_recursos_classroom(ID, Recursos),
        print_sucesso('Recursos atualizados com sucesso!'), nl
    ; print_erro('Sala não encontrada!'), nl
    ),
    pause, submenu_sala.

processar_submenu_sala("2") :-
    write('ID da sala: '), read_line_to_string(user_input, ID),
    ( classroom(ID, _, _, _) ->
        read_capacity(Capacidade),
        update_capacity(ID, Capacidade),
        print_sucesso('Capacidade atualizada com sucesso!'), nl
    ; print_erro('Sala não encontrada!'), nl
    ),
    pause, submenu_sala.

processar_submenu_sala("3") :-
    write('Voltando ao menu anterior...'), nl.

processar_submenu_sala(_) :-
    print_erro('Opção inválida!'), pause,
    submenu_sala.

submenu_turma :-
    draw_header("EDITAR TURMA"),
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
    visualizar_turmas,
    write('ID da turma: '), read_line_to_string(user_input, ID), nl,
    edit_schedule(ID),
    nl, submenu_turma.
processar_submenu_turma("2") :- write('Editando requisitos...'),
    visualizar_turmas,
    write('ID da turma: '), read_line_to_string(user_input, ID), nl,
    read_recursos([],Recursos),
    altera_requisitos_class(ID, Recursos),
    nl, submenu_turma.
processar_submenu_turma("3") :-
    visualizar_turmas, 
    write('ID da turma: '), read_line_to_string(user_input, ID),
    write('ID do novo professor: ') , read_line_to_string(user_input, Prof),
    realoca_prof(ID, Prof), 
    submenu_turma.
processar_submenu_turma("4") :- 
    visualizar_turmas,
    write('ID da turma: '), read_line_to_string(user_input, ID),
    write('Quantidade de alunos: '), read_line_to_string(user_input, Qtde),
    altera_quantidade(ID, Qtde),
    nl, submenu_turma.
processar_submenu_turma("5") :- 
    visualizar_turmas,
    write('ID da turma: '), read_line_to_string(user_input, ID),
    remove_class(ID), nl, submenu_turma.
processar_submenu_turma("6") :- write('Voltando ao menu anterior...'), nl, admin_menu.
processar_submenu_turma(_) :- print_erro('Opcao invalida!\n'), pause, submenu_turma.

entry_class :-
    draw_header("CADASTRO DE TURMA"),
    read_classId(ID),
    read_disciplina(id,Disciplina),
    read_curso(id,Curso),
    listar_professores,
    read_professor_id(ProfessorID),
    read_schedule(ID, _, _),
    read_capacity(Capacidade),
    read_recursos([],Requisitos),
    assertz(class(ID, Disciplina, Curso, ProfessorID, Capacidade, Requisitos)),
    save_classes('rules/classes.pl'),
    admin_menu.

entry_classroom :-
    draw_header("CADASTRO DE SALA"),
    consult('rules/classrooms.pl'),
    read_classroomId(ID),
    write('Bloco: '), read_line_to_string(user_input, Bloco),
    read_capacity(Capacidade),
    read_recursos([],Recursos),
    assertz(classroom(ID, Bloco, Capacidade, Recursos)),
    save_classrooms('rules/classrooms.pl'),
    admin_menu.

edit_classroom_capacity :-
    consult('rules/classrooms.pl'),
    get_classroom(ID),
    read_capacity(Capacidade),
    update_capacity(ID,Capacidade).

edit_classroom_resources :-
    consult('rules/classrooms.pl'),
    get_classroom(ID),
    read_recursos([],Recursos),
    update_resources_classroom(ID,Recursos).

alterar_horario_turma(ID) :-
    edit_schedule(ID).