:- encoding(utf8).
:- dynamic(class/6).
:- dynamic(classroom/4).
:- dynamic(user/4).

read_classId(ID) :-
    write('ID da turma: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (class(Input, _, _, _, _, _) -> (print_erro('Já existe uma turma com esse ID. Tente novamente.\n'), read_classId(ID)) 
        ; ID = Input)
    ).

read_disciplina(id, Disciplina) :-
    draw_header("CADASTRO DE TURMA"),
    write('Informe o número da disciplina:\n'),
    listar_disciplinas,
    read_line_to_string(user_input, Input),
    (disciplina(Input, Disciplina) -> true
        ;print_erro('Disciplina inválida. Tente novamente.\n'), read_disciplina(id, Disciplina)
    ).

read_curso(id,Curso) :-
    draw_header("CADASTRO DE TURMA"),
    write('Informe o número do Curso:\n'),
    listar_cursos,
    read_line_to_string(user_input, Input),
    (curso(Input, Curso) -> true
        ;print_erro('Curso invalido. Tente novamente.\n'), pause, read_curso(id,Curso)
    ).

read_recursos(Acumulados, Requisitos) :-
    write('Escolha os Requisitos\n'),
    print_colorido("1.Projetor   2.Acessibilidade    3.Quadro Branco     4.Laboratório\n", green),
    read_line_to_string(user_input, Input),
    (recursos(Input, NomeRequisito) ->
        (member(NomeRequisito, Acumulados) ->  
            print_erro('Requisito já escolhido. Tente outro.\n'), read_recursos(Acumulados, Requisitos)
            ;print_colorido('Deseja adicionar mais algum requisito? (s/n) ', yellow), read_line_to_string(user_input, ChoiceRaw),
            string_lower(ChoiceRaw, Choice),
            (Choice = "s" ->  read_recursos([NomeRequisito|Acumulados], Requisitos) ; Requisitos = [NomeRequisito|Acumulados])
        )
        ;print_erro('Requisito inválido. Tente novamente.\n'), read_recursos(Acumulados, Requisitos)
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
        (print_erro('Já existe um usuário com esse ID. Tente novamente.\n'), pause, register_screen) 
        ; ID = Input)
    ; print_erro('ID inválido! Digite novamente.\n'),
      read_user_id(ID)
    ).

read_func_user(Role) :-
    print_colorido('Função do usuário:', yellow), nl,
    print_colorido('[0] ', yellow),
    write('Administrador'), nl,
    print_colorido('[1] ', yellow),
    write('Professor'), nl,
    write('Escolha: '),
    read_line_to_string(user_input, Input),
    ( Input = "0" ->
        ( user(_, _, _, "Admin") ->
            print_erro('Já existe um administrador cadastrado. Tente novamente.\n'),
            pause,
            register_screen
        ; Role = "Admin"
        )
    ; Input = "1" ->
        Role = "Prof"
    ; print_erro('Opção inválida. Tente novamente.\n'),
      read_func_user(Role)
    ).

read_capacity(Capacidade) :-
    write('Capacidade: '), 
    read_line_to_string(user_input, Input),
    ( number_string(Number, Input), Number > 0 ->
        Capacidade = Number
    ; print_erro('Capacidade inválida. Digite um número positivo.\n'),
      read_capacity(Capacidade)
    ).

read_professor_id(ID) :-
    draw_header("CADASTRO DE TURMA"),
    listar_professores,
    write('Digite o ID do professor responsável: '),
    read_line_to_string(user_input, Input),
    ( user(Input, _, _, "Prof") ->
        ID = Input
    ; print_erro('Professor não encontrado! Digite apenas uma ID válida.\n'), pause,
      read_professor_id(ID)
    ).

valida_turma(ID_Turma) :-
    class(ID_Turma, _, _, _, _, _), 
    !.                             
valida_turma(ID_Turma) :- 
    \+ class(ID_Turma, _, _, _, _, _), 
    print_erro("Erro: turma com ID "), print_erro(ID_Turma), print_erro(" não encontrada.\n"),
    fail.                         

get_classroom(ID) :-
    write('ID da sala: '), read_line_to_string(user_input, Input),
    (number_string(Number, Input), Number > 0 ->
        (classroom(Input, _, _, _) -> (ID = Input) 
        ; (print_erro('Não existe uma sala com esse ID. Tente novamente.\n'), get_classroom(ID)))
    ).

listar_disciplinas :-
    findall((Cod, Nome), disciplina(Cod, Nome), Lista),
    list(Lista).

listar_professores :-
    findall((ID, Nome), user(ID, Nome, _, "Prof"), Lista),
    (   Lista = [] ->
        print_erro("Nenhum professor encontrado."), nl
    ;   list(Lista)
    ).


list([]).
list([(C1, N1),(C2,N2)|T]) :-
    format('~|~w. ~w~t~60+~|~w. ~w~n', [C1,N1,C2,N2]),
    list(T).

listar_cursos :- 
    forall(curso(Cod,Nome), format('~w. ~w~n', [Cod,Nome])).