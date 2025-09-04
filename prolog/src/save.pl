save_classes('src/rules/classes.pl') :-
    open('src/rules/classes.pl', write, Stream),
    forall(
        class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Recursos),
        (writeq(Stream, class(ID, Disciplina, Curso, ProfessorID, Horario, Vagas, Recursos)), write(Stream, '.'), nl(Stream))
    ),
    close(Stream).

load_classes('src/rules/classes.pl') :-
    consult('src/rules/classes.pl').