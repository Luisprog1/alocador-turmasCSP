:- encoding(utf8).
:- dynamic(class/6).
:- dynamic(classroom/4).
:- dynamic(user/4).

read_classId(ID) :-
    write('ID da turma: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (class(Input, _, _, _, _, _) -> (write('Já existe uma turma com esse ID. Tente novamente.\n'), read_classId(ID)) 
        ; ID = Input)
    ).

read_disciplina(id, Disciplina) :-
    write('Informeo o número da disciplina:\n'),
    listar_disciplinas,
    read_line_to_string(user_input, Input),
    (disciplina(Input, Disciplina) -> true
        ;write('Disciplina inválida. Tente novamente.\n'), read_disciplina(id, Disciplina)
    ).

read_curso(id,Curso) :-
    write('Informe o número do Curso:\n'),
    listar_cursos,
    read_line_to_string(user_input, Input),
    (curso(Input, Curso) -> true
        ;write('Curso invalido. Tente novamente.\n'), read_curso(id,Curso)
    ).

read_recursos(Acumulados, Requisitos) :-
    write('Escolha os Requisitos\n'),
    write("1.Projetor   2.Acessibilidade    3.Quadro Branco     4.Laboratório\n"),
    read_line_to_string(user_input, Input),
    (recursos(Input, NomeRequisito) ->
        (member(NomeRequisito, Acumulados) ->  
            write('Requisito já escolhido. Tente outro.\n'), read_recursos(Acumulados, Requisitos)
            ;write('Deseja adicionar mais algum requisito? (s/n) '), read_line_to_string(user_input, Choice),
            (Choice = "s" ->  read_recursos([NomeRequisito|Acumulados], Requisitos) ; Requisitos = [NomeRequisito|Acumulados])
        )
        ;write('Requisito inválido. Tente novamente.\n'), read_recursos(Acumulados, Requisitos)
    ).

read_classroomId(ID) :-
    write('ID da sala: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (classroom(Input, _, _, _) -> (write('Já existe uma sala com esse ID. Tente novamente.\n'), read_classroomId(ID)) 
        ; ID = Input)
    ).
    
read_user_id(ID) :-
    write('ID do usuário: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (user(Input, _, _, _) -> 
        (write('Já existe um usuário com esse ID. Tente novamente.\n'), read_user_id(ID)) 
        ; ID = Input)
    ; write('ID inválido! Digite novamente.\n'),
      read_user_id(ID)
    ).

read_func_user(Role) :-
    write('Função do usuário [0 | 1]:'), nl,
    write('[0] Administrador'), nl,
    write('[1] Professor'), nl,
    write('Escolha: '),
    read_line_to_string(user_input, Input),
    ( Input = "0" ->
        ( user(_, _, _, "Admin") ->
            write('Já existe um administrador cadastrado. Tente novamente.\n'),
            read_func_user(Role)
        ; Role = "Admin"
        )
    ; Input = "1" ->
        Role = "Prof"
    ; write('Opção inválida. Tente novamente.\n'),
      read_func_user(Role)
    ).

read_capacity(Capacidade) :-
    write('Capacidade: '), 
    read_line_to_string(user_input, Input),
    ( number_string(Number, Input), Number > 0 ->
        Capacidade = Number
    ; write('Capacidade inválida. Digite um número positivo.\n'),
      read_capacity(Capacidade)
    ).

read_professor_id(ID) :-
    write('Digite o ID do professor responsável: '),
    read_line_to_string(user_input, Input),
    ( user(Input, _, _, "Prof") ->
        ID = Input
    ; write('Professor não encontrado! Digite apenas uma ID válida.\n'),
      read_professor_id(ID)
    ).


get_classroom(ID) :-
    write('ID da sala: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (classroom(Input, _, _, _) -> (ID = Input) 
        ; (write('Não existe uma sala com esse ID. Tente novamente.\n'), get_classroom(ID)))
    ).

listar_disciplinas :-
    findall((Cod, Nome), disciplina(Cod, Nome), Lista),
    list(Lista).

listar_professores :-
    write('Professores disponíveis:'), nl,
    forall(user(ID, Nome, _, "Prof"),
           format('ID: ~w - Nome: ~w~n', [ID, Nome])),
    nl.


list([]).
list([(C1, N1),(C2,N2)|T]) :-
    format('~|~w. ~w~t~60+~|~w. ~w~n', [C1,N1,C2,N2]),
    list(T).

listar_cursos :- 
    forall(curso(Cod,Nome), format('~w. ~w~n', [Cod,Nome])).