module Utils.Resources where
import Tipos
import Data.Char (toLower)
import Data.List (nub, find)
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)



resourcesMenu :: String
resourcesMenu = unlines [  "1. Projetor"
                         , "2. Laboratório"
                         , "3. Acessibilidade"
                         , "4. Quadro Branco"
                         ]

-- | Função auxiliar para converter uma string em um recurso. Usada no menu de recursos (ou requisitos).
parseResource :: String -> Resource
parseResource op = case op of
  "1"     -> Projector
  "2"    -> Laboratory
  "3"  -> Acessibility
  "4" -> Whiteboard
  _ -> error ("Recurso inexistente")

-- | Adiciona um recurso a uma turma com base no ID da turma.
addResources :: Resource -> Int -> [Class] -> IO [Class]
addResources resource classID clss = do
    let clss' = map (\c -> if classId c == classID then c {requirements = nub (resource : requirements c)} else c) clss
    return clss'

-- | Remove um recurso de uma turma com base no ID da turma.
removeResources :: Resource -> Int -> [Class] -> IO [Class]
removeResources resource classID clss= do
    let clss' = map (\c -> if classId c == classID then c { requirements = filter (/= resource) (requirements c) } else c) clss
    return clss'

-- | Verifica se o professor tem permissão para alterar os requisitos da turma.
verifyIfProfessorHasClass :: [Class] -> Int -> Int -> Int -> Maybe Bool
verifyIfProfessorHasClass classes typeId profId clssId =
  if typeId == 0 then Just True else do
  clss <- find (\c -> classId c == clssId) classes
  return (professorId clss == profId)


-- | Adiciona ou remove requisitos de uma turma.
change_requirements :: [Class] -> Int -> Int -> IO [Class]
change_requirements classes typeId profId = do
    putStrLn "Informe o ID da turma:"
    hFlush stdout
    classId <- getLine
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
            putStrLn "1. Adicionar"
            putStrLn "2. Remover"
            hFlush stdout
            op <- getLine
            case op of
              "1" -> do
                putStrLn resourcesMenu
                hFlush stdout
                req <- getLine
                clss' <- addResources (parseResource req) classId classes
                return clss'
              "2" -> do
                putStrLn resourcesMenu
                req <- getLine
                clss' <- removeResources (parseResource req) classId classes
                return clss'
              _ -> do
                putStrLn "Opção inválida. Tente novamente."
                change_requirements classes typeId profId
