:- encoding(utf8).
:- ensure_loaded('dados.pl').
:- ensure_loaded('repository/save.pl').
:- consult('rules/horarios_turmas.pl').
:- dynamic(horario_turma/3).

menu_dia("1", 'Segunda') :- !.
menu_dia("2", 'Terça'):- !.
menu_dia("3", 'Quarta'):- !.
menu_dia("4", 'Quinta'):- !.
menu_dia("5", 'Sexta'):- !.

menu_hora("1", '08-10'):- !.
menu_hora("2", '10-12'):- !.
menu_hora("3", '14-16'):- !.
menu_hora("4", '16-18'):- !.
menu_hora("5", '18-20'):- !.
menu_hora("6", '20-22'):- !.

read_schedule(Id_turma, Dia, Hora):-
    write('Escolha um dia (ou digite n para inserir depois):'), nl,
    write('1. Segunda   2. Terça    3. Quarta   4. Quinta    5. Sexta'), nl,
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
      write('1. [08-10] 2. [10-12] 3. [14-16] 4. [16-18] 5. [18-20] 6. [20-22]'), nl,
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
