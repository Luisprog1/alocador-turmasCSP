:- encoding(utf8).
:- use_module(library(ansi_term)).

pause :-
    ansi_format([fg(yellow)], "~w", ["Pressione ENTER para continuar..."]),
    read_line_to_string(user_input, _).

print_erro(Msg) :-
    ansi_format([fg(red)], "~w~n", [Msg]).

print_sucesso(Msg) :-
    ansi_format([fg(green)], "~w~n", [Msg]).

print_colorido(Msg, Cor) :-
    ansi_format([fg(Cor)], "~w", [Msg]).
