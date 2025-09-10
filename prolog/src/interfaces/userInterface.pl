:- encoding(utf8).
:- ensure_loaded('repository/userRepository.pl').
:- ensure_loaded('interfaces/UI.pl').

user_screen :-
    draw_header('BEM-VINDO AO SISTEMA'),
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
    draw_header('CADASTRO DE USUÁRIO'),
    entry_user.

login_screen :-
    draw_header('LOGIN'),
    ( login_user -> true ; user_screen ).
