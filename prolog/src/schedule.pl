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
    write('1. Segunda   2. Terça    3. Quarta   4. Quinta    5. Sexta'), nl.

print_menu_horas :-
    write('1. [08-10] 2. [10-12] 3. [14-16] 4. [16-18] 5. [18-20] 6. [20-22]'), nl.

read_schedule(Id_turma, Dia, Hora):-
    write('Escolha um dia (ou digite n para inserir depois):'), nl,
    print_menu_dias,
    read_line_to_string(user_input, Dia_op),
    ( Dia_op = "n" ->
        !, write('Encerrando entrada de horários.'), nl,
        Dia = none, Hora = none
    ; menu_dia(Dia_op, Dia) ->
        true
    ; write('Opção inválida, tente novamente.'), nl,
      read_schedule(Id_turma, Dia2, Hora2)
    ),
    ( Dia == none -> true
    ; write('Escolha o horário:'), nl,
      print_menu_horas,
      read_line_to_string(user_input, Hora_op),
      ( Hora_op = "n" ->
           Dia = none, Hora = none
      ; menu_hora(Hora_op, Hora) ->
           true
      ; write('Opção inválida, tente novamente.'), nl,
        read_schedule(Id_turma, Dia2, Hora2)
      ),
      ( Dia == none -> true
      ; ( horario_turma(Id_turma, Dia, Hora) ->
            write('Erro: turma já possui aula nesse horário.'), nl,
            read_schedule(Id_turma, Dia2, Hora2)
        ; assertz(horario_turma(Id_turma, Dia, Hora)),
          save_ocupacao_sala('rules/horarios_turmas.pl'),
          write('Horário adicionado com sucesso.'), nl,
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
    ; write('Opção inválida, tente novamente.'), nl,
      choose_dia(NovoDia)
    ).

choose_hora(NovoHora) :-
    print_menu_horas,
    read_line_to_string(user_input, HoraOp),
    ( menu_hora(HoraOp, NovoHora) -> true
    ; write('Opção inválida, tente novamente.'), nl,
      choose_hora(NovoHora)
    ).

editar_horario(ID, Lista) :-
    write('Escolha o número do horário para editar: '),
    read_line_to_string(user_input, EscolhaStr),
    number_string(Escolha, EscolhaStr),
    nth1(Escolha, Lista, (DiaAntigo, HoraAntiga)),
    format("Selecionado: ~w - ~w~n", [DiaAntigo, HoraAntiga]),
    write('Escolha o dia:'), nl,
    choose_dia(NovoDia),
    write('Escolha o horário:'), nl,
    choose_hora(NovoHora),
    retract(horario_turma(ID, DiaAntigo, HoraAntiga)),
    assertz(horario_turma(ID, NovoDia, NovoHora)),
    save_ocupacao_sala('rules/horarios_turmas.pl'),
    write('Horário atualizado com sucesso!'), nl.

adicionar_horario(ID) :-
    choose_dia(NovoDia),
    choose_hora(NovoHora),
    ( horario_turma(ID, NovoDia, NovoHora) ->
        write('Erro: esse horário já está cadastrado.'), nl
    ; assertz(horario_turma(ID, NovoDia, NovoHora)),
      save_ocupacao_sala('rules/horarios_turmas.pl'),
      write('Novo horário adicionado com sucesso!'), nl
    ).

remover_horario(ID, Lista) :-
    write('Escolha o número do horário para remover: '),
    read_line_to_string(user_input, EscolhaStr),
    number_string(Escolha, EscolhaStr),
    nth1(Escolha, Lista, (DiaRem, HoraRem)),
    retract(horario_turma(ID, DiaRem, HoraRem)),
    save_ocupacao_sala('rules/horarios_turmas.pl'),
    format("Horário ~w - ~w removido com sucesso!~n", [DiaRem, HoraRem]).

edit_schedule(ID) :-
    findall((Dia, Hora), horario_turma(ID, Dia, Hora), Lista),
    (   Lista \= []
    ->  write('Horários encontrados:'), nl,
        listar_horarios(Lista, 1),
        nl, write('Opções:'), nl,
        write('1. Editar horário existente'), nl,
        write('2. Adicionar novo horário'), nl,
        write('3. Remover horário existente'), nl,
        read_line_to_string(user_input, Opcao),
        ( Opcao = "1" -> editar_horario(ID, Lista)
        ; Opcao = "2" -> adicionar_horario(ID)
        ; Opcao = "3" -> remover_horario(ID, Lista)
        ; write('Opção inválida.'), nl, fail
        )
    ;   write('Nenhum horário encontrado para essa turma.'), nl, fail
    ).