:- dynamic(class/6).
:- ensure_loaded('save.pl').
:- ensure_loaded('../interfaces/adminInterface.pl').
:- consult('../rules/classes.pl').
:- consult('../rules/users.pl').
:- encoding(utf8).

remove_class(IdTurma) :- 
    ( class(IdTurma, _, _, _, _, _) ->
        retract(class(IdTurma, _, _, _, _, _)),
        save_classes('rules/classes.pl'),
        format(string(TEXTO), 'Turma ~w removida com sucesso.~n', [IdTurma]),
        print_sucesso(TEXTO),
        pause
    ; 
        print_erro('Turma não encontrada!'), nl, pause, submenu_turma
    ).
realoca_prof(IdTurma, IdProf) :- 
    (class(IdTurma, Disciplina, Curso, _, Capacidade, Requisitos) -> true; 
    print_erro('Turma não encontrada!'), nl, pause, submenu_turma
    ),
    (user(IdProf, _,_,_) -> true;
    print_erro("Professor não encontrado!"), nl, pause, submenu_turma
    ),
    retract(class(IdTurma,_,_,_,_,_)),
    assertz(class(IdTurma, Disciplina, Curso, IdProf, Capacidade, Requisitos)),
    save_classes('rules/classes.pl').

altera_quantidade(IdTurma, Qtde) :-
    (class(IdTurma, Disciplina, Curso, Prof, _, Requisitos) -> true; 
    print_erro('Turma não encontrada!'), nl, pause, submenu_turma
    ),
     retract(class(IdTurma,_,_,_,_,_)),
    assertz(class(IdTurma, Disciplina, Curso, Prof, Qtde, Requisitos)),
    save_classes('rules/classes.pl').

altera_requisitos_class(ID, Recursos) :-
    class(ID, Disciplina,Curso,Professor, QTD, _),
    retract(class(ID, _, _, _, _, _)),
    assertz(class(ID, Disciplina,Curso,Professor, QTD, Recursos)),
    save_classes('rules/classes.pl').

valida_altera_requisitos(ID_Turma, ID_Usuario) :-
    (   class(ID_Turma, _, _, ID_Usuario, _, _) -> true
    ;   print_erro("Erro: você não tem permissão para alterar esta turma\n"),
        fail
    ).
