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

read_disciplina(Disciplina) :-
    write('disciplina: '), read_line_to_string(user_input, Input),
    (validate_disciplina(Input) -> Disciplina = Input ; (write('Disciplina invalida. Tente novamente.\n'), read_disciplina(Disciplina))).

read_curso(Curso) :-
    write('curso: '), read_line_to_string(user_input, Input),
    (validate_curso(Input) -> Curso = Input ; (write('Curso invalido. Tente novamente.\n'), read_curso(Curso))).

read_recursos(Acumulados, Requisitos) :-
    write('Escolha os Requisitos\n'),
    write("1.Projetor 2.Acessibilidade 3.Quadro Branco 4.Laboratório\n"),
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
        (user(Input, _, _, _) -> (write('Já existe um usuário com esse ID. Tente novamente.\n'), read_user_id(ID)) 
        ; ID = Input)
    ).

read_func_user(Role) :-
    write('Função do usuário (admin/professor): '), read_line_to_string(user_input, Input),
    (role(Input) ->
        (Input = "admin",
            user(_, _, _, "admin") -> write('Já existe um administrador cadastrado. Tente novamente.\n'), read_func_user(Role)
            ;Role = Input
        )
        ;write('Função inválida. Tente novamente.\n'), read_func_user(Role)
    ).

read_capacity(Capacidade) :-
    write('Capacidade: '), 
    read_line_to_string(user_input, Input),
    ( number_string(Number, Input), Number > 0 ->
        Capacidade = Number
    ; write('Capacidade inválida. Digite um número positivo.\n'),
      read_capacity(Capacidade)
    ).