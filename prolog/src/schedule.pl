:- encoding(utf8).
:- ensure_loaded('dados.pl').
:- ensure_loaded('repository/save.pl').
:- consult('rules/horarios_turmas.pl').
:- dynamic(horario_turma/3).

menu_dia("1", 'Segunda') :- !.
menu_dia("2", 'Terça')   :- !.
menu_dia("3", 'Quarta')  :- !.
menu_dia("4", 'Quinta')  :- !.
menu_dia("5", 'Sexta')   :- !.

menu_hora("1", '08-10'):- !.
menu_hora("2", '10-12'):- !.
menu_hora("3", '14-16'):- !.
menu_hora("4", '16-18'):- !.
menu_hora("5", '18-20'):- !.
menu_hora("6", '20-22'):- !.

print_menu_dias :-
    print_colorido('1', yellow), write('. Segunda   '),
    print_colorido('2', yellow), write('. Terça    '),
    print_colorido('3', yellow), write('. Quarta   '),
    print_colorido('4', yellow), write('. Quinta   '),
    print_colorido('5', yellow), write('. Sexta'),
    nl.

print_menu_horas :-
    print_colorido('1', yellow), write('. [08-10]  '),
    print_colorido('2', yellow), write('. [10-12]  '),
    print_colorido('3', yellow), write('. [14-16]  '),
    print_colorido('4', yellow), write('. [16-18]  '),
    print_colorido('5', yellow), write('. [18-20]  '),
    print_colorido('6', yellow), write('. [20-22]'),
    nl.

read_schedule(Id_turma, Dia, Hora):-
    draw_header("CADASTRO DE TURMA"),
    print_colorido('Escolha um dia (ou digite n para inserir depois):', yellow), nl,
    print_menu_dias,
    read_line_to_string(user_input, Dia_op),
    ( Dia_op = "n" ->
        !, write('Encerrando entrada de horários.'), nl,
        Dia = none, Hora = none
    ; menu_dia(Dia_op, Dia) ->
        true
    ; print_erro('Opção inválida, tente novamente.\n'), pause, nl,
      read_schedule(Id_turma, Dia2, Hora2)
    ),
    ( Dia == none -> true
    ; print_colorido('Escolha o horário:', yellow), nl,
      print_menu_horas,
      read_line_to_string(user_input, Hora_op),
      ( Hora_op = "n" ->
           Dia = none, Hora = none
      ; menu_hora(Hora_op, Hora) ->
           true
      ; print_erro('Opção inválida, tente novamente.\n'), pause, nl,
        read_schedule(Id_turma, Dia2, Hora2)
      ),
      ( Dia == none -> true
      ; ( horario_turma(Id_turma, Dia, Hora) ->
            print_erro('Erro: turma já possui aula nesse horário.'), pause, nl,
            read_schedule(Id_turma, Dia2, Hora2)
        ; assertz(horario_turma(Id_turma, Dia, Hora)),
          save_ocupacao_sala('rules/horarios_turmas.pl'),
          print_sucesso('Horário adicionado com sucesso.'), nl,
          write('Deseja adicionar mais algum horário? (s/n) '), read_line_to_string(user_input, Choice),
            (Choice = "s" -> read_schedule(Id_turma, Dia2, Hora2); !)
        )
      )
    ).

listar_horarios([], _).
listar_horarios([(Dia, Hora)|Resto], N) :-
    format("~w. ~w - ~w~n", [N, Dia, Hora]),
    N1 is N + 1,
    listar_horarios(Resto, N1).

choose_dia(NovoDia) :-
    print_menu_dias,
    read_line_to_string(user_input, DiaOp),
    ( menu_dia(DiaOp, NovoDia) -> true
    ; print_erro('Opção inválida, tente novamente.\n'), nl,
      choose_dia(NovoDia)
    ).

choose_hora(NovoHora) :-
    print_menu_horas,
    read_line_to_string(user_input, HoraOp),
    ( menu_hora(HoraOp, NovoHora) -> true
    ; print_erro('Opção inválida, tente novamente.\n'), nl,
      choose_hora(NovoHora)
    ).

editar_horario(ID, Lista) :-
    print_colorido('\nEscolha o número do horário para editar: ', yellow),
    read_line_to_string(user_input, EscolhaStr),
    number_string(Escolha, EscolhaStr),
    nth1(Escolha, Lista, (DiaAntigo, HoraAntiga)),
    format(string(SelecionadoStr), "Selecionado: ~w - ~w", [DiaAntigo, HoraAntiga]),
    print_colorido(SelecionadoStr, green), nl,
    print_colorido('Escolha o novo dia:', yellow), nl,
    choose_dia(NovoDia),
    print_colorido('Escolha o novo horário:', yellow), nl,
    choose_hora(NovoHora),
    retract(horario_turma(ID, DiaAntigo, HoraAntiga)),
    assertz(horario_turma(ID, NovoDia, NovoHora)),
    save_ocupacao_sala('rules/horarios_turmas.pl'),
    print_sucesso('Horário atualizado com sucesso!\n'), pause.

adicionar_horario(ID) :-
    print_colorido("ESCOLHA O DIA:\n", yellow),
    choose_dia(NovoDia),
    print_colorido("ESCOLHA O HORÁRIO:\n", yellow),
    choose_hora(NovoHora),
    ( horario_turma(ID, NovoDia, NovoHora) ->
        print_erro('Erro: esse horário já está cadastrado.'), nl, pause
    ; assertz(horario_turma(ID, NovoDia, NovoHora)),
      save_ocupacao_sala('rules/horarios_turmas.pl'),
      print_sucesso('Novo horário adicionado com sucesso!'), nl, pause
    ).

remover_horario(ID, Lista) :-
    write('Escolha o número do horário para remover: '),
    read_line_to_string(user_input, EscolhaStr),
    number_string(Escolha, EscolhaStr),
    nth1(Escolha, Lista, (DiaRem, HoraRem)),
    retract(horario_turma(ID, DiaRem, HoraRem)),
    save_ocupacao_sala('rules/horarios_turmas.pl'),
    format(string(TEXTO),"Horário ~w - ~w removido com sucesso!~n", [DiaRem, HoraRem]), 
    print_sucesso(TEXTO), pause.

edit_schedule(ID) :-
    findall((Dia, Hora), horario_turma(ID, Dia, Hora), Lista),
    (   Lista \= []
    ->  print_colorido('Horários encontrados:', yellow), nl,
        listar_horarios(Lista, 1),
        nl, print_colorido('Opções:', yellow), nl,
        write('1. Editar horário existente'), nl,
        write('2. Adicionar novo horário'), nl,
        write('3. Remover horário existente'), nl,
        read_line_to_string(user_input, Opcao),
        ( Opcao = "1" -> editar_horario(ID, Lista)
        ; Opcao = "2" -> adicionar_horario(ID)
        ; Opcao = "3" -> remover_horario(ID, Lista)
        ; print_erro('Opção inválida.\n'), pause, edit_schedule(ID)
        )
    ;   % Caso não haja horários, já chama adicionar
        format(string(Title), "EDITAR HORÁRIO DA TURMA ~w", [ID]),
        draw_header(Title),
        write("Essa turma não possui horários disponíveis.\n"),
        print_colorido('Adicione um novo horário para ela:', yellow), nl,
        adicionar_horario(ID)
    ).