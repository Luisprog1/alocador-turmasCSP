:- encoding(utf8).
:- dynamic(class/6).
:- dynamic(classroom/4).
:- dynamic(user/4).

save_classes(File) :-
    open(File, write, Stream),
    forall(
        class(ID, Disciplina, Curso, ProfessorID, Capacidade, Requisitos),
        (writeq(Stream, class(ID, Disciplina, Curso, ProfessorID, Capacidade, Requisitos)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).

save_classrooms(File) :-
    open(File, write, Stream),
    forall(
        classroom(ID, Capacidade, Bloco, Recursos),
        (writeq(Stream, classroom(ID, Capacidade, Bloco, Recursos)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).

save_users(File) :-
    open(File, write, Stream),
    forall(
        user(ID, Nome, Senha, Role),
        (writeq(Stream, user(ID, Nome, Senha, Role)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).

save_ocupacao_sala(File) :- 
    open(File, write, Stream), 
    forall(   
        horario_turma(Id_turma, Dia, Hora), 
        (writeq(Stream, horario_turma(Id_turma, Dia, Hora)), write(Stream, '.'), nl(Stream)) 
    ), 
    close(Stream).