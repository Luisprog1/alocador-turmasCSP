:- dynamic(class/7).
:- ensure_loaded('dados.pl').
:- ensure_loaded('save.pl').


menu_dia("1", 'Segunda') :- !.
menu_dia("2", 'Terca'):- !.
menu_dia("3", 'Quarta'):- !.
menu_dia("4", 'Quinta'):- !.
menu_dia("5", 'Sexta'):- !.
menu_dia(_) :- 
    write('Opcao invalida, tente novamente.'),
    read_day.

menu_hora("1", '08-10'):- !.
menu_hora("2", '10-12'):- !.
menu_hora("3", '14-16'):- !.
menu_hora("4", '16-18'):- !.
menu_hora("5", '18-20'):- !.
menu_hora("6", '20-22'):- !.
menu_hora(_) :-
    write('Opcao invalida, tente novamente.'),
    read_day.

read_day(Id_sala, (Dia, Hora)):-
    write('Escolha um dia:\n'),
    write('1. Segunda   2. Terca    3. Quarta\n4. Quinta    5. Sexta\n'),
    read_line_to_string(user_input, Dia_op),
    menu_dia(Dia_op, Dia),
    write('Escolha o horario:\n'),
    write('1. [08-10]   2. [10-12]  3. [14-16]\n4. [16-18]  5. [18-20]  6.[20-22]\n'),
    read_line_to_string(user_input, Hora_op),
    menu_hora(Hora_op, Hora),
    assertz(horario_ocupado(Id_sala, Dia, Hora)),
    save_ocupacao_sala('rules/horarios_ocupados_sala.pl').

