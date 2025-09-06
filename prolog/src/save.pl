save_classes(File) :-
    open(File, write, Stream),
    forall(
        class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Recursos),
        (writeq(Stream, class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Requisitos)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).

save_classrooms(File) :-
    open(File, write, Stream),
    forall(
        classroom(ID, Capacity, Block, Resources, Schedule),
        (writeq(Stream, classroom(ID, Block, Capacity, Resources, Schedule)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).