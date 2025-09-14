:- dynamic(class/6).
:- dynamic(classroom/4).
:- dynamic(user/4).
:- use_module(library(strings)).
:- ensure_loaded('dados.pl').
:- ensure_loaded('repository/save.pl').
:- ensure_loaded('repository/utils-classroom.pl').
:- ensure_loaded('validacao.pl').
:- ensure_loaded('schedule.pl').
:- ensure_loaded('interfaces/userInterface.pl').
:- consult('rules/users.pl').
:- consult('rules/classes.pl').
:- encoding(utf8).

entry_class :-
    read_classId(ID),
    read_disciplina(id,Disciplina),
    read_curso(id,Curso),
    listar_professores,
    read_professor_id(ProfessorID),
    write('horario: '), read_schedule(ID, _, _),
    read_capacity(Capacidade),
    read_recursos([],Requisitos),
    assertz(class(ID, Disciplina, Curso, ProfessorID, Capacidade, Requisitos)),
    save_classes('rules/classes.pl').

entry_classroom :-
    consult('rules/classrooms.pl'),
    read_classroomId(ID),
    write('Bloco: '), read_line_to_string(user_input, Bloco),
    read_capacity(Capacidade),
    read_recursos([],Recursos),
    assertz(classroom(ID, Bloco, Capacidade, Recursos)),
    save_classrooms('rules/classrooms.pl').

edit_classroom_capacity :-
    consult('rules/classrooms.pl'),
    get_classroom(ID),
    read_capacity(Capacidade),
    update_capacity(ID,Capacidade).

edit_classroom_resources :-
    consult('rules/classrooms.pl'),
    get_classroom(ID),
    read_recursos([],Recursos),
    update_resources_classroom(ID,Recursos).

alterar_horario_turma(ID) :-
    edit_schedule(ID).