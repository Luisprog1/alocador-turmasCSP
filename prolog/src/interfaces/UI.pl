ansi_clear :- write('\e[2J').
ansi_home :- write('\e[H').
ansi_color(Color) :- format('\e[~wm', [Color]).
ansi_reset :- write('\e[0m').

color_yellow :- ansi_color(33).
color_cyan   :- ansi_color(36).
color_blue   :- ansi_color(34).

logo :-
    color_yellow,
    write('   █████╗ ██╗      ██████╗  ██████╗  █████╗ ██████╗  ██████╗  ██████╗  \n'),
    write('  ██╔══██╗██║     ██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗██╔═══██╗ ██╔══██╗ \n'),
    write('  ███████║██║     ██║   ██║██║      ███████║██   ██║██║   ██║ ██████╔╝ \n'),
    write('  ██╔══██║██║     ██║   ██║██║      ██╔══██║██   ██║██║   ██║ ██╔══██╗ \n'),
    write('  ██║  ██║███████╗╚██████╔╝╚██████╔ ██║  ██║███████╝╚██████╔╝ ██║  ██║ \n'),
    write('  ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚═╝  ╚═╝ \n'),
    ansi_reset.

draw_header(Title) :-
    ansi_clear, ansi_home,
    logo, nl,
    color_cyan,
    format("===============  ~w  ===============~n", [Title]),
    ansi_reset, nl.

draw_subheader(Sub) :-
    color_blue,
    format("~w ---~n", [Sub]),
    ansi_reset.

trim(Str, Trimmed) :-
    atom_string(A, Str),
    normalize_space(atom(T), A),
    atom_string(T, Trimmed).

read_line(Prompt, Line) :-
    write(Prompt), flush_output,
    read_line_to_string(user_input, Input),
    trim(Input, Trimmed),
    ( Trimmed = "" ->
        write('Entrada vazia, tente novamente.\n'),
        read_line(Prompt, Line)
    ; Line = Trimmed
    ).

read_line_maybe(Prompt, Line) :-
    write(Prompt), flush_output,
    read_line_to_string(user_input, Input),
    trim(Input, Line).
