:- encoding(utf8).
:- dynamic(user/4).
:- ensure_loaded('repository/save.pl').
:- consult('rules/users.pl').
:- ensure_loaded('validacao.pl').
:- ensure_loaded('interfaces/adminInterface').
:- ensure_loaded('interfaces/profInterface').
:- ensure_loaded('../repository/utils.pl').

entry_user :-
    read_user_id(ID),
    write('Nome: '), read_line_to_string(user_input, Nome),
    write('Senha: '), read_line_to_string(user_input, Senha),
    read_func_user(Role),
    assertz(user(ID, Nome, Senha, Role)),
    save_users('rules/users.pl'),
    print_sucesso('Usuário registrado com sucesso!\n'),
    pause,
    user_screen.

login_user :-
    write('Matrícula: '), read_line_to_string(user_input, ID),
    write('Senha: '), read_line_to_string(user_input, Senha),
    (   user(ID, NOME, Senha, Role) ->
        (Role = "Admin" -> admin_menu;
        Role = "Prof" -> professor_menu(ID, NOME)
        )
    ;   print_erro('Falha no login: matrícula ou senha incorretos.\n'), pause, user_screen
    ).
