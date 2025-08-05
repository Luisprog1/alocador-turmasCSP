module View.AdminView where

import Tipos
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Utils.Resources
import View.UI 
import View.ClassView 
import View.ProfessorView 
import Repository.ClassRepository 
import View.ClassroomView 
import Repository.ClassroomRepository 
import Repository.UserRepository

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

sub_menu :: [Classroom] -> String -> IO [Classroom]
sub_menu classroom idClassroom = do
    drawHeader "SUBMENU SALA"
    putStrLn "1. Editar os recursos da sala"
    putStrLn "2. Editar a capacidade da sala"
    putStrLn "3. Salvar e sair"
    hFlush stdout
    opcao <- getLine
    case opcao of
        "1" -> do
            putStrLn "Informe os novos requisitos (separados por vírgula, ex: Projector, Laboratory):"
            hFlush stdout
            recursos <- getLine
            let novosRecursos = map parseResource (splitOn ", " recursos)
            putStrLn "Alterando requisitos da sala..."
            let classroom' = map (\c -> if classroomCode c == idClassroom then c { resources = novosRecursos } else c) classroom
            putStrLn "Requisitos da turma alterados com sucesso na memória."
            sub_menu classroom' idClassroom 
        "2" -> do
            putStrLn "Informa a nova capacidade da sala:"
            hFlush stdout
            cap <- getLine
            case readMaybe cap :: Maybe Int of
                Nothing -> do 
                    putStrLn "ID inválido. Por favor, insira um número inteiro válido."
                    sub_menu classroom idClassroom
                Just cap -> do
                    let classroom' = map (\c -> if classroomCode c == idClassroom then c { capacity = cap } else c) classroom
                    sub_menu classroom' idClassroom
        "3" -> do
            saveAllClassrooms (classroom)
            return classroom
        _  -> do
            putStrLn "Opção inválida!"
            sub_menu classroom idClassroom 


edit_classroom :: [Classroom] -> IO[Classroom]
edit_classroom classroom = do
    putStrLn "Informe o Código da sala que deseja alterar:"
    hFlush stdout
    idClassroom <- getLine
    case getClassroomByCode classroom idClassroom of
        Nothing -> do
            putStrLn "Código errado. Por favor, insira um número inteiro válido."
            edit_classroom classroom
        Just idClassroomInt -> do
            updatedClassroom <- sub_menu classroom idClassroom
            return updatedClassroom
            