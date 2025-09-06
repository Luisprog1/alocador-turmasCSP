:- dynamic(class/7).
:- dynamic(classroom/5).
:- dynamic(user/4).
:- use_module(library(strings)).
:- ensure_loaded('dados.pl').
:- ensure_loaded('save.pl').
:- ensure_loaded('validacao.pl').
:- consult('rules/users.pl').
:- consult('rules/classes.pl').
:- encoding(utf8).

entry_class :-
    read_classId(ID),
    read_disciplina(Disciplina),
    read_curso(Curso),
    write('professor: '), read_line_to_string(user_input, ProfessorID),
    write('horario: '), read_line_to_string(user_input, Horario),
    write('vagas: '), read_line_to_string(user_input, Vagas),
    read_recursos([],Requisitos),
    assertz(class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Requisitos)),
    save_classes('src/rules/classes.pl').

entry_classroom :-
    read_classroomId(ID)    ,
    write('Bloco: '), read_line_to_string(user_input, Block),
    write('Capacidade: '), read_line_to_string(user_input, Capacity),
    write('Recursos: '), read_line_to_string(user_input, Resources),
    assertz(classroom(ID, Block, Capacity, Resources, '')),
    save_classrooms('src/rules/classrooms.pl').


entry_user :-
    read_user_id(ID),
    write('Nome: '), read_line_to_string(user_input, Name),
    write('Senha: '), read_line_to_string(user_input, Password),
    read_func_user(Role),
    assertz(user(ID, Name, Password, Role)),
    save_users('src/rules/users.pl').

validate_disciplina(Disciplina) :-
    disciplina(Disciplina), !.

validate_curso(Curso) :-
    curso(Curso), !.