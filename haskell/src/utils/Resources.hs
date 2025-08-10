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

-- | Menu de recursos disponíveis
resourcesMenu :: String
resourcesMenu = unlines [" 1. Projetor         2. Laboratório"
                          , " 3. Acessibilidade  4. Quadro Branco"
                          , " Pressione Enter para sair" ]                       

-- | Esta função é responsável por mapear as opções do menu para os tipos de recursos correspondentes.
--
-- * op: opção selecionada pelo usuário
parseResource :: String -> Resource
parseResource op = case op of
  "1"     -> Projector
  "2"    -> Laboratory
  "3"  -> Acessibility
  "4" -> Whiteboard
  _ -> error ("Recurso inexistente")

-- | Lê os recursos do usuário e retorna uma lista de recursos.
-- Se o usuário pressionar Enter sem digitar nada, a lista é retornada como está
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

-- | Função auxiliar que adiciona um requisito a uma turma com base no ID da turma.
--
-- * resource: recurso a ser adicionado
-- * classID: ID da turma da qual o recurso será adicionado
-- * classes: lista de turmas
addRequirements :: Resource -> Int -> [Class] -> IO [Class]
addRequirements resource classID classes = do
    let classes' = map (\c -> if classId c == classID then c {requirements = nub (resource : requirements c)} else c) classes
    return classes'
    
-- | Função auxiliar que remove um requisito de uma turma com base no ID da turma.
--
-- * resource: recurso a ser removido
-- * classID: ID da turma da qual o recurso será removido
-- * classes: lista de turmas
removeRequirements :: Resource -> Int -> [Class] -> IO [Class]
removeRequirements resource classID classes = do
    let classes' = map (\c -> if classId c == classID then c { requirements = filter (/= resource) (requirements c) } else c) classes
    return classes'

-- | Verifica se o professor tem permissão para alterar os requisitos da turma.
--
-- * classes: lista de turmas
-- * typeId: tipo de usuário (0 para admin, 1 para professor)
-- * profId: ID do professor
-- * clssId: ID da turma
verifyIfProfessorHasClass :: [Class] -> Int -> Int -> Int -> Maybe Bool
verifyIfProfessorHasClass classes typeId profId clssId =
  if typeId == 0 then Just True else do
  clss <- find (\c -> classId c == clssId) classes
  return (professorId clss == profId)


-- | Adiciona ou remove requisitos de uma turma. 
-- 
-- * classes: lista de turmas
-- * typeId: tipo de usuário (0 para admin, 1 para professor)
-- * profId: ID do professor
change_requirements :: [Class] -> Int -> Int -> Int -> IO [Class]
change_requirements classes typeId profId classId = do
    case verifyIfProfessorHasClass classes typeId profId classId of
      Nothing -> do
        putStrLn "Turma não encontrada. Tente novamente."
        change_requirements classes typeId profId classId
      Just False -> do
        putStrLn "Você não tem permissão para alterar os requisitos desta turma."
        putStrLn "Pressione Enter para continuar..."
        stop <- getLine
        return classes
      Just True -> do
            drawHeader "ALTERAR REQUISITOS"
            putStrLn "1. Adicionar requisito"
            putStrLn "2. Remover requisito"
            putStrLn "3. Salvar e sair"
            hFlush stdout
            op <- getLine
            case op of
              "1" -> do
                drawSubHeader "Escolha uma opção:"
                putStrLn resourcesMenu
                hFlush stdout
                req <- getLine
                if null req then do
                  change_requirements classes typeId profId classId
                else if req `notElem` ["1", "2", "3", "4"] then do
                  putStrLn "Opção inválida. Tente novamente."
                  change_requirements classes typeId profId classId
                else do
                  clss' <- addRequirements (parseResource req) classId classes
                  return clss'
              "2" -> do
                drawSubHeader "Escolha uma opção:"
                putStrLn resourcesMenu
                req <- getLine
                clss' <- removeRequirements (parseResource req) classId classes
                return clss'
              "3" -> do
                saveAllClasses (classes)
                return classes
              _ -> do
                putStrLn "Opção inválida. Tente novamente."
                change_requirements classes typeId profId classId

-- | Adiciona um recurso a uma sala de aula com base no código da sala.
--
-- * resource: recurso a ser adicionado
-- * classroomCode': código da sala onde o recurso será adicionado
-- * classrooms: lista de salas de aula
addResources :: Resource -> String -> [Classroom] -> IO [Classroom]
addResources resource classroomCode' classrooms = do
    let classrooms' = map (\c -> if classroomCode c == classroomCode'
                                    then c { resources = nub (resource : resources c) }
                                    else c) classrooms
    return classrooms'

-- | Remove um recurso de uma sala de aula com base no código da sala.
--
-- * resource: recurso a ser removido
-- * classroomCode': código da sala onde o recurso será removido
-- * classrooms: lista de salas de aula
removeResources :: Resource -> String -> [Classroom] -> IO [Classroom]
removeResources resource classroomCode' classrooms = do
    let classrooms' = map (\c -> if classroomCode c == classroomCode'
                                    then c { resources = filter (/= resource) (resources c) }
                                    else c) classrooms
    return classrooms'

-- | Adiciona ou remove recursos de uma sala de aula.
--
-- * classrooms: lista de salas de aula
-- * idClassroom: código da sala de aula
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
        hFlush stdout
        req <- getLine
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
        hFlush stdout
        req <- getLine
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

-- | Verifica se um recurso é válido.
--
-- * op: opção selecionada pelo usuário
verifyResource :: String -> Maybe Resource
verifyResource op = case op of
  "1" -> Just Projector
  "2" -> Just Laboratory
  "3" -> Just Acessibility
  "4" -> Just Whiteboard
  _   -> Nothing

