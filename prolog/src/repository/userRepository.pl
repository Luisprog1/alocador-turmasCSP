:- encoding(utf8).
:- dynamic(user/4).
:- ensure_loaded('repository/save.pl').
:- consult('rules/users.pl').

entry_user :-
    read_user_id(ID),
    write('Nome: '), read_line_to_string(user_input, Nome),
    write('Senha: '), read_line_to_string(user_input, Senha),
    read_func_user(Role),
    assertz(user(ID, Nome, Senha, Role)),
    save_users('rules/users.pl'),
    write('Usuário registrado com sucesso!\n').

login_user :-
    write('Matrícula: '), read_line_to_string(user_input, ID),
    write('Senha: '), read_line_to_string(user_input, Senha),
    (   user(ID, Nome, Senha, Role) ->
        format("Login bem-sucedido! Bem-vindo, ~w ~w.\n", [Role, Nome]), !
    ;   write('Falha no login: matrícula ou senha incorretos.\n'), fail
    ).
