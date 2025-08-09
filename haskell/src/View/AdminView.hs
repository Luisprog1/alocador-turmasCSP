module View.AdminView where

import Tipos
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Utils.Resources
import Utils.Alocate
import Utils.Schedule  
import View.UI 
import View.ClassView 
import View.ProfessorView 
import View.ClassroomView 
import Repository.AlocateRepository
import Repository.ClassRepository
import Repository.ClassroomRepository 
import Repository.UserRepository
import System.Console.ANSI

-- | Menu principal do administrador
adminMenu :: Int -> [Class] -> [Classroom] -> IO ([Class], [Classroom])
adminMenu id classes classroom = do
    drawHeader "ADMINISTRADOR"
    putStrLn "Escolha uma opção"
    putStrLn "1. Gerar alocação"
    putStrLn "2. Cadastrar Professor"
    putStrLn "3. Cadastrar Sala"
    putStrLn "4. Cadastrar Turma"
    putStrLn "5. Editar Sala"
    putStrLn "6. Editar Turma"
    putStrLn "7. Sair e salvar"
    putStr "Opção: "
    hFlush stdout
    opcao <- getLine
    case opcao of
        "1" -> do
            classroom' <- generateAllocs classes classroom
            putStrLn $ "Pressione enter para continuar"
            stop <- getLine
            adminMenu id classes classroom'
        "2" -> do
            createProfessor
            adminMenu id classes classroom
        "3" -> do 
            classroom' <- createClassRoom classroom
            putStrLn "Sala cadastrada com sucesso!"
            adminMenu id classes classroom'
        "4" -> do 
            classes' <- createClass classes
            putStrLn "Turma cadastrada com sucesso!"
            adminMenu id classes' classroom
        "5" -> do 
            classroom' <- edit_classroom classroom
            adminMenu id classes classroom'
        "6" -> do
            classes' <- change_requirements classes 0 id
            adminMenu id classes' classroom
        "7" -> do
            saveAllClasses classes
            return (classes, classroom)
        _ -> do
            putStrLn "Opção inválida!"
            adminMenu id classes classroom


generateAllocs :: [Class] -> [Classroom] -> IO [Classroom]
generateAllocs clss classrooms = do
    let emptyRooms = resetClassrooms classrooms
    let (allocationResult, finalId, newClassrooms) = backtrackAllocate 1 clss emptyRooms
    case allocationResult of
        Right allocations -> do
            saveAllocs allocations
            return newClassrooms
        Left conflictCls -> do
            putStrLn $ "Conflito encontrado com a turma: " ++ show (classId conflictCls)
            return classrooms
            
-- | Função para cadastrar professor (pré-cadastro sem senha)
createProfessor :: IO ()
createProfessor = do
    putStrLn "Informe a matrícula do professor:"
    matriculaStr <- getLine
    putStrLn "Informe o nome do professor:"
    nome <- getLine

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

sub_menu_classroom :: [Classroom] -> String -> IO [Classroom]
sub_menu_classroom classroom idClassroom = do
    drawHeader "SUBMENU SALA"
    putStrLn "1. Editar os recursos da sala"
    putStrLn "2. Editar a capacidade da sala"
    putStrLn "3. Salvar e sair"
    hFlush stdout
    opcao <- getLine
    case opcao of
        "1" -> do
            updatedclassroom <- change_resources classroom idClassroom
            sub_menu_classroom updatedclassroom idClassroom
        "2" -> do
            setSGR [SetColor Foreground Dull Blue]
            putStrLn "Informa a nova capacidade da sala:"
            setSGR [Reset]
            hFlush stdout
            cap <- getLine
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


edit_classroom :: [Classroom] -> IO [Classroom]
edit_classroom classrooms = do
    putStrLn "Informe o Código da sala que deseja alterar:"
    hFlush stdout
    idClassroom <- getLine
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
            