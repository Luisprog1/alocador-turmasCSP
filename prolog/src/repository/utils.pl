:- encoding(utf8).
:- use_module(library(ansi_term)).

print_colorido(Msg, Cor) :-
    ansi_format([fg(Cor)], "~w", [Msg]).

pause :-
    print_colorido("Pressione ENTER para continuar...", yellow),
    read_line_to_string(user_input, _).

print_erro(Msg) :-
    print_colorido(Msg, red).

print_sucesso(Msg) :-
    print_colorido(Msg, green).

