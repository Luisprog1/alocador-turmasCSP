module Utils.Resources where
import Tipos
import Data.Char (toLower)
import Data.List (nub, find)
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)
import View.UI (drawHeader)
import Repository.ClassroomRepository (getClassroomByCode)
import Control.Monad.RWS (MonadState(put))
import System.Console.ANSI
import Repository.ClassRepository
import View.UI


resourcesMenu :: String
resourcesMenu = unlines [" 1. Projetor         2. Laboratório"
                          , " 3. Acessibilidade  4. Quadro Branco"
                          , " Presssione Enter para sair" ]
                          


-- | Função auxiliar para converter uma string em um recurso. Usada no menu de recursos (ou requisitos).
parseResource :: String -> Resource
parseResource op = case op of
  "1"     -> Projector
  "2"    -> Laboratory
  "3"  -> Acessibility
  "4" -> Whiteboard
  _ -> error ("Recurso inexistente")

readResources :: [Resource] -> IO [Resource]
readResources acc = do
    putStrLn resourcesMenu
    putStr "Digite o requisito (ou pressione Enter para finalizar):"
    hFlush stdout
    resourceOp <- getLine
    if null resourceOp
        then return acc
        else do
          let r = parseResource resourceOp
          if r `elem` acc
             then do
               putStrLn "Recurso já adicionado. Digite outro ou pressione Enter para finalizar.\n"
               readResources acc
             else
               readResources (acc ++ [r])


-- =========================
-- ADIÇÃO DE REQUISITOS DAS TURMAS
-- =========================

-- | Adiciona um recurso a uma turma com base no ID da turma.
addRequirements :: Resource -> Int -> [Class] -> IO [Class]
addRequirements resource classID clss = do
    let clss' = map (\c -> if classId c == classID then c {requirements = nub (resource : requirements c)} else c) clss
    return clss'

-- | Remove um recurso de uma turma com base no ID da turma.
removeRequirements :: Resource -> Int -> [Class] -> IO [Class]
removeRequirements resource classID clss= do
    let clss' = map (\c -> if classId c == classID then c { requirements = filter (/= resource) (requirements c) } else c) clss
    return clss'

-- | Verifica se o professor tem permissão para alterar os requisitos da turma.
verifyIfProfessorHasClass :: [Class] -> Int -> Int -> Int -> Maybe Bool
verifyIfProfessorHasClass classes typeId profId clssId =
  if typeId == 0 then Just True else do
  clss <- find (\c -> classId c == clssId) classes
  return (professorId clss == profId)


-- | Adiciona ou remove requisitos de uma turma. 
-- Recebe como parâmetros todas as turmas, o typeId: 0 para admin, 1 para professor, e a matrícula do professor ou ADM.
change_requirements :: [Class] -> Int -> Int -> IO [Class]
change_requirements classes typeId profId = do
    drawHeader "ALTERAR REQUISITOS"
    classId <- readLine "Informe o ID da turma: "
    case verifyIfProfessorHasClass classes typeId profId (read classId) of
      Nothing -> do
        putStrLn "Turma não encontrada. Tente novamente."
        change_requirements classes typeId profId
      Just False -> do
        putStrLn "Você não tem permissão para alterar os requisitos desta turma."
        change_requirements classes typeId profId
      Just True ->
        case readMaybe classId :: Maybe Int of
          Nothing -> do
            putStrLn "ID inválido. Por favor, insira um número inteiro válido."
            change_requirements classes typeId profId
          Just classId -> do
            drawHeader "ALTERAR REQUISITOS"
            putStrLn "1. Adicionar requisito"
            putStrLn "2. Remover requisito"
            putStrLn "3. Salvar e sair"
            op <- readLine " "
            case op of
              "1" -> do
                drawSubHeader "Escolha uma opção:"
                putStrLn resourcesMenu
                req <- readLine " "
                if null req then do
                  change_requirements classes typeId profId
                else if req `notElem` ["1", "2", "3", "4"] then do
                  putStrLn "Opção inválida. Tente novamente."
                  change_requirements classes typeId profId
                else do
                  clss' <- addRequirements (parseResource req) classId classes
                  return clss'
              "2" -> do
                drawSubHeader "Escolha uma opção:"
                putStrLn resourcesMenu
                req <- readLine " "
                clss' <- removeRequirements (parseResource req) classId classes
                return clss'
              "3" -> do
                saveAllClasses (classes)
                return classes
              _ -> do
                putStrLn "Opção inválida. Tente novamente."
                change_requirements classes typeId profId
                
-- =========================
-- ADIÇÃO DE RECURSOS DAS SALAS
-- =========================

-- | Adiciona um recurso a uma sala de aula com base no código da sala.
addResources :: Resource -> String -> [Classroom] -> IO [Classroom]
addResources resource classroomCode' clssrms = do
    let clssrms' = map (\c -> if classroomCode c == classroomCode'
                                then c { resources = nub (resource : resources c) }
                                else c) clssrms
    return clssrms'

-- | Remove um recurso de uma sala de aula com base no código da sala.
removeResources :: Resource -> String -> [Classroom] -> IO [Classroom]
removeResources resource classroomCode' clssrms = do
    let clssrms' = map (\c -> if classroomCode c == classroomCode'
                                then c { resources = filter (/= resource) (resources c) }
                                else c) clssrms
    return clssrms'

-- | Adiciona ou remove recursos de uma sala de aula.
change_resources :: [Classroom] -> String -> IO [Classroom]
change_resources classrooms idClassroom = do
    drawHeader "ALTERAR RECURSOS"
    drawSubHeader "Escolha uma opção:"
    putStrLn "1. Adicionar recurso"
    putStrLn "2. Remover recurso"
    putStrLn "Pressione Enter para voltar"
    hFlush stdout
    op <- getLine
    case op of
      "1" -> do
        drawSubHeader "Recursos disponíveis:"
        putStrLn resourcesMenu
        req <- readLine " "
        if null req then do
          change_resources classrooms idClassroom
        else case verifyResource req of
          Nothing -> do
            putStrLn "Opção inválida. Tente novamente."
            change_resources classrooms idClassroom
          Just r -> 
            case getClassroomByCode classrooms idClassroom of
              Nothing -> do
                putStrLn "Sala de aula não encontrada."
                return classrooms
              Just sala -> 
                if r `elem` resources sala then do
                  putStrLn "Recurso já existe na sala!"
                  change_resources classrooms idClassroom
                else do
                  clssrms' <- addResources r idClassroom classrooms
                  putStrLn "Recurso adicionado com sucesso!"
                  return clssrms'
      "2" -> do
        drawSubHeader "Escolha uma opção:"
        putStrLn resourcesMenu
        req <- readLine " "
        case verifyResource req of
          Nothing -> do
            putStrLn "Opção inválida. Tente novamente."
            change_resources classrooms idClassroom
          Just r -> do
            clssrms' <- removeResources r idClassroom classrooms
            putStrLn "Recurso removido com sucesso!"
            return clssrms'
      "" -> do
        return classrooms
      _ -> do
        putStrLn "Opção inválida. Tente novamente."
        change_resources classrooms idClassroom

verifyResource :: String -> Maybe Resource
verifyResource op = case op of
  "1" -> Just Projector
  "2" -> Just Laboratory
  "3" -> Just Acessibility
  "4" -> Just Whiteboard
  _   -> Nothing

