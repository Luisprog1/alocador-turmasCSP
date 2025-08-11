module Utils.Table
  ( drawAllocationsTable     
  , drawProfessorClassesTable
  , formatScheduleShort      
  ) where

import Tipos
import Data.List (intercalate, find)
import System.Console.ANSI
import Text.Printf (printf)
import Repository.UserRepository (User(..))

-- | Formata lista de (dia, hora) como "qui - 6, seg - 4"
formatScheduleShort :: [(Weekday, Int)] -> String
formatScheduleShort slots
  | null slots = "—"
  | otherwise  = intercalate ", " (map (\(d,h) -> shortWeekday d ++ " - " ++ show h) slots)

-- | Abreviação em minúsculas
shortWeekday :: Weekday -> String
shortWeekday Segunda = "seg"
shortWeekday Terca   = "ter"
shortWeekday Quarta  = "qua"
shortWeekday Quinta  = "qui"
shortWeekday Sexta   = "sex"
shortWeekday None    = "—"

-- | Desenha a tabela ASCII de alocações (Admin): ID | Professor | Sala | Horários | Turma
drawAllocationsTable :: [User] -> [Class] -> [Classroom] -> [Allocation] -> IO ()
drawAllocationsTable users classes _classrooms allocs = do
    let wId   = 4   :: Int
        wProf = 28  :: Int
        wSala = 10  :: Int
        wHora = 32  :: Int
        wTurm = 46  :: Int
        sep   = "│"
        hline = replicate (wId + wProf + wSala + wHora + wTurm + 4 * length sep + 4) '─'

    setSGR [SetColor Foreground Vivid Cyan]
    putStrLn hline
    printf ("%-"++show wId++"s %s %-"++show wProf++"s %s %-"++show wSala++"s %s %-"++show wHora++"s %s %-"++show wTurm++"s\n")
           "ID" sep "Professor" sep "Sala" sep "Horários" sep "Turma"
    putStrLn hline
    setSGR [Reset]

    mapM_ (printAllocRow users classes wId wProf wSala wHora wTurm sep) allocs

    setSGR [SetColor Foreground Vivid Cyan]
    putStrLn hline
    setSGR [Reset]

-- | Linha da tabela de alocações
printAllocRow :: [User] -> [Class] -> Int -> Int -> Int -> Int -> Int -> String -> Allocation -> IO ()
printAllocRow users classes wId wProf wSala wHora wTurm sep a = do
    let cid      = allocClassId a
        pid      = allocProfessorId a
        roomCode = allocClassroomCode a

        profName =
          maybe ("Matrícula " ++ show pid)
                userNome
                (find (\u -> userMatricula u == pid) users)

        (classTxt, schedTxt) =
          case find (\c -> classId c == cid) classes of
            Just c  -> ( subject c ++ " (" ++ course c ++ ") - Turma " ++ show (classId c)
                       , formatScheduleShort (schedule c)
                       )
            Nothing -> ("Turma " ++ show cid, "—")

    setSGR [SetColor Foreground Dull Yellow]
    printf ("%-"++show wId++"d") (allocationId a)
    setSGR [Reset]
    printf (" %s %-"++show wProf++"s %s %-"++show wSala++"s %s %-"++show wHora++"s %s %-"++show wTurm++"s\n")
           sep profName sep roomCode sep schedTxt sep classTxt

-- Abrevie diretamente o tipo Resource
abbrRequirement :: Resource -> String
abbrRequirement Projector    = "Proj"
abbrRequirement Whiteboard   = "Wboard"
abbrRequirement Acessibility = "Acess"
abbrRequirement Laboratory   = "Lab"

-- Formata lista de requisitos abreviados (recebe [Resource])
formatRequirementsShort :: [Resource] -> String
formatRequirementsShort = intercalate "," . map abbrRequirement

-- | Tabela de turmas do professor: ID | Horários | Alunos | Requisitos | Turma
drawProfessorClassesTable :: [Class] -> IO ()
drawProfessorClassesTable turmas = do
    let wId   = 4   :: Int
        wHora = 20  :: Int
        wAlun = 7   :: Int
        wReq  = 32  :: Int
        wTurm = 60  :: Int
        sep   = "│"
        hline = replicate (wId + wHora + wAlun + wReq + wTurm + 4 * length sep + 4) '─'

    setSGR [SetColor Foreground Vivid Cyan]
    putStrLn hline
    printf ("%-"++show wId++"s %s %-"++show wHora++"s %s %-"++show wAlun++"s %s %-"++show wReq++"s %s %-"++show wTurm++"s\n")
           "ID" sep "Horários" sep "Alunos" sep "Requisitos" sep "Turma"
    putStrLn hline
    setSGR [Reset]

    mapM_ (printClassRow wId wHora wAlun wReq wTurm sep) turmas

    setSGR [SetColor Foreground Vivid Cyan]
    putStrLn hline
    setSGR [Reset]

-- | Linha da tabela de turmas do professor (com requisitos abreviados)
printClassRow :: Int -> Int -> Int -> Int -> Int -> String -> Class -> IO ()
printClassRow wId wHora wAlun wReq wTurm sep c = do
    let schedTxt = formatScheduleShort (schedule c)          -- ex.: "seg - 2, qua - 1"
        alunos   = show (quantity c)
        reqs     = formatRequirementsShort (requirements c)  -- ex.: "Proj,Lab,Acess"
        turmaTxt = subject c ++ " (" ++ course c ++ ") - Turma " ++ show (classId c)

    setSGR [SetColor Foreground Dull Yellow]
    printf ("%-"++show wId++"d") (classId c)
    setSGR [Reset]
    printf (" %s %-"++show wHora++"s %s %-"++show wAlun++"s %s %-"++show wReq++"s %s %-"++show wTurm++"s\n")
           sep schedTxt sep alunos sep reqs sep turmaTxt
