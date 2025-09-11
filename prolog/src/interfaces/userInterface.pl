:- encoding(utf8).
:- ensure_loaded('repository/userRepository.pl').

user_screen :-
    nl,
    write('============================'), nl,
    write('     BEM-VINDO AO SISTEMA   '), nl,
    write('============================'), nl,
    write('1 - Registrar'), nl,
    write('2 - Login'), nl,
    write('============================'), nl,
    write('Escolha uma opção: '),
    read_line_to_string(user_input, Opt),
    ( Opt = "1" -> register_screen
    ; Opt = "2" -> login_screen
    ; nl, write('Opção inválida! Tente novamente.'), nl, user_screen
    ).

register_screen :-
    nl, write('--- CADASTRO DE USUÁRIO ---'), nl,
    entry_user.

login_screen :-
    nl, write('--- LOGIN ---'), nl,
    ( login_user -> true 
    ; user_screen ).
