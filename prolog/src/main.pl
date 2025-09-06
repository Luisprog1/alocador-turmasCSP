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
    write('requisitos: '), read_line_to_string(user_input, Requisitos),
    assertz(class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Requisitos)),
    save_classes('rules/classes.pl').

entry_classroom :-
    write('Código da sala: '), read_line_to_string(user_input, ID),
    write('Bloco: '), read_line_to_string(user_input, Block),
    write('Capacidade: '), read_line_to_string(user_input, Capacity),
    write('Recursos: '), read_line_to_string(user_input, Resources),
    assertz(classroom(ID, Block, Capacity, Resources, '')),
    save_classrooms('rules/classrooms.pl').
