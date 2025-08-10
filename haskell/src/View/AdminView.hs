module View.AdminView where
import Utils.Alocate
import Repository.AlocateRepository
import Tipos
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)
import Data.List (find)
import Utils.Resources
import View.UI 
import View.ClassView 
import View.ProfessorView 
import Repository.ClassRepository
import View.ClassroomView 
import Repository.ClassroomRepository 
import Repository.UserRepository
import System.Console.ANSI
import Utils.Schedule

-- | Menu principal do administrador
--- * id: ID do administrador
--- * classes: lista de turmas  
--- * classroom: lista de salas
adminMenu :: Int -> [Class] -> [Classroom] -> IO ([Class], [Classroom])
adminMenu id classes classroom = do
    drawHeader "ADMINISTRADOR"
    putStrLn "Escolha uma opção"
    putStrLn "1. Gerar alocação"
    putStrLn "2. Visualizar Alocações"
    putStrLn "3. Cadastrar Professor"
    putStrLn "4. Cadastrar Sala"
    putStrLn "5. Cadastrar Turma"
    putStrLn "6. Editar Sala"
    putStrLn "7. Editar Turma"
    putStrLn "8. Sair e salvar"
    opcao <- readLine "Opção: "
    case opcao of
        "1" -> do
            classroom' <- generateAllocs classes classroom
            adminMenu id classes classroom'
        "2" -> do
            viewAllocs
            adminMenu id classes classroom
        "3" -> do
            createProfessor
            adminMenu id classes classroom
        "4" -> do 
            classroom' <- createClassRoom classroom
            putStrLn "Sala cadastrada com sucesso!"
            adminMenu id classes classroom'
        "5" -> do 
            classes' <- createClass classes
            saveAllClasses classes'
            putStrLn "Turma cadastrada com sucesso!"
            adminMenu id classes' classroom
        "6" -> do 
            classroom' <- edit_classroom classroom
            adminMenu id classes classroom'
        "7" -> do
            classes' <- editClass id classes
            adminMenu id classes' classroom
        "8" -> do
            return (classes, classroom)
        _ -> do
            putStrLn "Opção inválida!"
            adminMenu id classes classroom

-- | Gera alocações para as turmas e salva no arquivo. Se houver conflito, retorna a sala original.
-- * clss: lista de turmas
-- * classrooms: lista de salas
generateAllocs :: [Class] -> [Classroom] -> IO [Classroom]
generateAllocs clss classrooms = do
    let emptyRooms = resetClassrooms classrooms
    let (allocationResult, finalId, newClassrooms) = backtrackAllocate 1 clss emptyRooms
    case allocationResult of
        Right allocations -> do
            saveAllocs allocations
            putStrLn $ show (finalId - 1) ++ " alocações realizadas\nPressione enter para continuar"
            stop <- getLine
            return newClassrooms
        Left conflictCls -> do
            putStrLn $ "Conflito encontrado com a turma: " ++ show (classId conflictCls)
            return classrooms

-- | Visualiza todas as alocações salvas
viewAllocs :: IO ()
viewAllocs = do
    allocs <- getAllocs
    mapM_ print allocs
    putStrLn $ "Pressione enter para continuar"
    stop <- getLine
    return()

-- | Função para cadastrar professor (pré-cadastro sem senha)
createProfessor :: IO ()
createProfessor = do
    
    matriculaStr <- readLine "Informe a matrícula do professor: "
    nome <- readLine "Informe o nome do professor:"

    let matricula = read matriculaStr :: Int

    users <- getUsers
    let existe = any (\u -> userMatricula u == matricula) users

    if existe
        then putStrLn "Já existe um professor com essa matrícula!"
        else do
            -- SALVA COM SENHA VAZIA
            let novoProfessor = User 1 matricula nome ""
            saveAllUsers (users ++ [novoProfessor])
            putStrLn "Professor cadastrado com sucesso!"

-- | SubMenu para editar capacidade ou recursos de uma sala de aula já validada
-- * classroom: lista de salas
-- * idClassroom: código da sala a ser editada
sub_menu_classroom :: [Classroom] -> String -> IO [Classroom]
sub_menu_classroom classroom idClassroom = do
    drawHeader "SUBMENU SALA"
    putStrLn "1. Editar os recursos da sala"
    putStrLn "2. Editar a capacidade da sala"
    putStrLn "3. Salvar e sair"
    opcao <- readLine " "
    case opcao of
        "1" -> do
            updatedclassroom <- change_resources classroom idClassroom
            sub_menu_classroom updatedclassroom idClassroom
        "2" -> do
            setSGR [SetColor Foreground Dull Blue]
            cap <- readLine "Informe a nova capacidade da sala:"
            setSGR [Reset]
            case readMaybe cap :: Maybe Int of
                Nothing -> do 
                    putStrLn "ID inválido. Por favor, insira um número inteiro válido."
                    sub_menu_classroom classroom idClassroom
                Just cap -> do
                    let classroom' = map (\c -> if classroomCode c == idClassroom then c { capacity = cap } else c) classroom
                    sub_menu_classroom classroom' idClassroom
        "3" -> do
            saveAllClassrooms (classroom)
            return classroom
        _  -> do
            putStrLn "Opção inválida!"
            sub_menu_classroom classroom idClassroom

-- | Função para editar uma sala de aula
--- * classrooms: lista de salas
edit_classroom :: [Classroom] -> IO [Classroom]
edit_classroom classrooms = do
    idClassroom <- readLine "Informe o Código da sala que deseja alterar:"
    if null idClassroom then do
        putStrLn "Edição cancelada."
        return classrooms
    else do
        let maybeClassroom = case filter (\c -> idClassroom == classroomCode c) classrooms of
                                []    -> Nothing
                                (c:_) -> Just c
        case maybeClassroom of
            Nothing -> do
                putStrLn "Código errado. Por favor, insira um código válido, ou pressione Enter para cancelar."
                edit_classroom classrooms
            Just classroomObj -> do
                let code = classroomCode classroomObj
                updatedClassrooms <- sub_menu_classroom classrooms code
                return updatedClassrooms

-- | Função para editar uma turma
--- * idAdmin: ID do administrador
--- * classes: lista de turmas
editClass :: Int -> [Class] -> IO [Class]
editClass idAdmin classes = do
    id <- readLine "Informe o ID da turma que deseja editar (ou pressione Enter para cancelar):"
    if null id then do
        putStrLn "Edição cancelada."
        return classes
    else do
        case readMaybe id :: Maybe Int of
            Nothing -> do
                putStrLn "ID inválido. Por favor, insira um número inteiro válido."
                editClass idAdmin classes
            Just id -> do
                let maybeClass = find (\c -> classId c == id) classes
                case maybeClass of
                    Nothing -> do
                        putStrLn "Turma não encontrada. Tente novamente."
                        editClass idAdmin classes
                    Just classObj -> do
                        putStrLn $ "Editando turma: " ++ show (classId classObj)
                        classes' <- classSubMenu idAdmin classes (classId classObj)
                        return classes'

-- | Submenu para editar uma turma já validada
--- * idAdmin: ID do administrador
--- * allClasses: lista de turmas
--- * clssId: ID da turma a ser editada
classSubMenu :: Int -> [Class] -> Int -> IO [Class]
classSubMenu idAdmin allClasses clssId = do
    case find (\c -> classId c == clssId) allClasses of
        Nothing -> do
            putStrLn "Turma não encontrada."
            return allClasses
        Just clss -> do
            drawSubHeader "SUBMENU TURMA"
            putStrLn "1. Editar Horários"
            putStrLn "2. Editar requisitos"
            putStrLn "3. Realocar novo professor"
            putStrLn "4. Editar quantidade de alunos"
            putStrLn "5. Remover turma"
            putStrLn "6. Voltar"
            opcao <- readLine " "
            case opcao of
                "1" -> do
                    updatedClasses <- editSchedule allClasses clss
                    classSubMenu idAdmin updatedClasses clssId
                "2" -> do
                    updatedClasses <- change_requirements allClasses 0 idAdmin clssId
                    classSubMenu idAdmin updatedClasses clssId
                "3" -> do
                    users <- getUsers
                    let professores = filter (\u -> userTipo u == 1) users
                    setSGR [SetColor Foreground Vivid Green]
                    putStrLn "Professores Disponíveis:\n"
                    mapM_ (putStrLn . ("  -  " ++) . userNome) professores
                    setSGR [Reset]
                    profIdStr <- readLine "Informe o ID do novo professor:"
                    case readMaybe profIdStr :: Maybe Int of
                        Nothing -> do
                            putStrLn "ID inválido. Por favor, insira um número inteiro válido."
                            classSubMenu idAdmin allClasses clssId
                        Just profId -> do
                            let updatedClass = clss { professorId = profId }
                            let updatedClasses = map (\c -> if classId c == classId clss then updatedClass else c) allClasses
                            putStrLn "Professor atualizado com sucesso!"
                            classSubMenu idAdmin updatedClasses (classId updatedClass)
                "4" -> do
                    qtdStr <- readLine "Informe a nova quantidade de alunos:"
                    case readMaybe qtdStr :: Maybe Int of
                        Nothing -> do
                            putStrLn "Quantidade inválida. Por favor, insira um número inteiro válido."
                            classSubMenu idAdmin allClasses clssId
                        Just qtd -> do
                            let updatedClass = clss { quantity = qtd }
                            let updatedClasses = map (\c -> if classId c == classId clss then updatedClass else c) allClasses
                            putStrLn "Quantidade de alunos atualizada com sucesso!"
                            classSubMenu idAdmin updatedClasses (classId updatedClass)
                "6" -> do
                    saveAllClasses allClasses
                    return allClasses
                _   -> do
                    putStrLn "Opção inválida!"
                    classSubMenu idAdmin allClasses clssId

-- | Função para adicionar ou remover os horários de uma turma
-- * allClasses: lista de turmas
-- * clss: turma a ser editada
editSchedule :: [Class] -> Class -> IO [Class]
editSchedule allClasses clss = do
    drawSubHeader "Escolha uma ação:"
    putStrLn "[a] Adicionar horário"
    putStrLn "[r] Remover horário"
    action <- readLine " "
    case action of
        "a" -> do
            newScheduleSlots <- readSchedule []
            let updatedClass = addSlotToClass clss newScheduleSlots
            let updatedClasses = map (\c -> if classId c == classId clss then updatedClass else c) allClasses
            putStrLn "Horários atualizados com sucesso!"
            mapM_ (putStrLn . show) (updatedClasses)
            return updatedClasses
        "r" -> do
            putStrLn "Horários atuais:"
            mapM_ (putStrLn . show) (schedule clss)
            putStrLn "Informe o dia do horário que deseja remover:\n[1] Segunda   [2] Terça   [3] Quarta   [4] Quinta   [5] Sexta"
            dayStr <- readLine " "
            putStrLn "Informe a hora do horário que deseja remover:\n[1] 08:00 - 10:00   [2] 10:00 - 12:00   [3] 14:00 - 16:00\n[4] 16:00 - 18:00   [5] 18:00 - 20:00   [6] 20:00 - 22:00"
            hourStr <- readLine " "
            case (readMaybe dayStr :: Maybe Int, readMaybe hourStr :: Maybe Int) of
                (Just dayNum, Just hourNum) | dayNum >= 1 && dayNum <= 5 && hourNum >= 1 && hourNum <= 6 -> do
                    let day = parseSchedule dayStr
                    let slotToRemove = (day, hourNum)
                    let updatedClass = removeSlotFromClass clss slotToRemove
                    let updatedClasses = map (\c -> if classId c == classId clss then updatedClass else c) allClasses
                    putStrLn "Horário removido com sucesso!"
                    return updatedClasses
                _ -> do
                    putStrLn "Entrada inválida. Tente novamente."
                    return allClasses
        _ -> do 
            putStrLn "Entrada inválida. Tente novamente."
            return allClasses