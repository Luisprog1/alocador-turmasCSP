module View.AdminView where

import Tipos
import System.IO (hFlush, stdout)
import Data.Char (toLower)
import Text.Read (readMaybe)
import Data.List.Split (splitOn)
import Repository.ClassRepository
import View.UI (drawHeader)
import View.ClassView (createClass)
import View.ProfessorView (change_requirements)
import Repository.ClassRepository (getClass, saveAllClasses)
import View.ClassroomView (createClassRoom)


adminMenu :: [Class] -> [Classroom] -> IO ([Class], [Classroom])
adminMenu classes classroom = do
    drawHeader "ADMINISTRADOR"
    putStrLn "Escolha uma opção"
    putStrLn "1. Gerar alocação"
    putStrLn "2. Cadastrar Sala"
    putStrLn "3. Cadastrar Turma"
    putStrLn "4. Editar Sala"
    putStrLn "5. Editar Turma"
    putStrLn "6. Sair e salvar"
    putStr "Opção: "
    hFlush stdout
    opcao <- getLine
    case opcao of
        --"1" -> do 
        "2" -> do 
            classroom' <- createClassRoom classroom
            putStrLn "Sala cadastrada com sucesso!"
            adminMenu classes classroom'
        "3" -> do 
            classes' <- createClass classes
            putStrLn "Turma cadastrada com sucesso!"
            adminMenu classes' classroom
        --"4" -> do
        "5" -> do
            classes' <- change_requirements classes
            adminMenu classes' classroom
        "6" -> do
            saveAllClasses classes
            return (classes, classroom)
        _ -> do
            putStrLn "Opção inválida!"
            adminMenu classes classroom
