:- dynamic(class/7).
:- ensure_loaded('dados.pl').
:- ensure_loaded('save.pl').
:- consult('rules/classes.pl').

entry_class :-
    write('ID: '), read_line_to_string(user_input, ID),
    write('disciplina: '), read_line_to_string(user_input, Disciplina),
    write('curso: '), read_line_to_string(user_input, Curso),
    write('professor: '), read_line_to_string(user_input, ProfessorID),
    write('horario: '), read_line_to_string(user_input, Horario),
    write('vagas: '), read_line_to_string(user_input, Vagas),
    write('recursos: '), read_line_to_string(user_input, Recursos),
    assertz(class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Recursos)),
    save_classes('rules/classes.pl').

entry_classroom :-
    write('Código da sala: '), read_line_to_string(user_input, Codigo_sala).