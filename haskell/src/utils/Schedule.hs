module Utils.Schedule where
import qualified Data.Map as Map
import Data.List (sort, nub)
import Tipos 
import Text.Read (readMaybe)
import System.IO (hFlush, stdout)
import System.Console.ANSI

-- | | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
scheduleContains :: ScheduleMap -> Weekday -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | | Retorna True se um tipo ScheduleMap contem 1 ou mais par ordenado (dia da semana, horario).
isAnyOccupation :: Classroom -> Class -> Bool
isAnyOccupation classroom clss = 
    any (\(day, hour) -> scheduleContains (roomSchedule classroom) day hour) (schedule clss)

addOccupation :: Class -> Classroom -> Classroom
addOccupation clss classroom 
    | isAnyOccupation classroom clss = classroom
    | otherwise =
         let
            addSlotsToSchedule :: [(Weekday, Int)] -> ScheduleMap -> ScheduleMap
            addSlotsToSchedule [] currentSchedule = currentSchedule -- | Base case: lista de slots vazia
            addSlotsToSchedule ((day, hour):restOfSchedule) currentSchedule =
                let
                    currHoursForDay = Map.findWithDefault [] day currentSchedule
                    updatedHoursForDay = sort . nub $ currHoursForDay ++ [hour]
                    scheduleAfterThisSlot = Map.insert day updatedHoursForDay currentSchedule
                in
                    addSlotsToSchedule restOfSchedule scheduleAfterThisSlot
        in
            classroom { roomSchedule = addSlotsToSchedule (schedule clss) (roomSchedule classroom) }

-- | | Passa a escolha da entrada para um dia do tipo Weekday.
-- | | Dica: coloquei números porque pode ser um menu de opcoes. 
parseSchedule :: String -> Weekday
parseSchedule str = case str of
  "1" -> Segunda
  "2" -> Terça
  "3" -> Quarta
  "4" -> Quinta
  "5" -> Sexta
  _   -> error "Invalid day string"

-- | | com base na entrada convertida do dia  e o horario da aula, cria uma tupla. !!
-- | | Sugestão: adicionar essas horas na turma com a funcao addSlotToClass
createHour :: Weekday -> Int -> (Weekday, Int)
createHour day hour = (day, hour)

addSlotToClass :: Class -> (Weekday, Int) -> Class
addSlotToClass clss (day, hour) 
    | elem (day, hour) (schedule clss) = clss
    | otherwise = 
        clss {schedule = schedule clss ++ [(day,hour)]}

-- | Limpa o agendamento de uma única sala de aula.
clearRoomSchedule :: Classroom -> Classroom
clearRoomSchedule room = room {
    roomSchedule = Map.empty -- Usa um Map vazio para limpar o agendamento
}

-- | Aplica a limpeza do agendamento em todas as salas da lista.
resetClassrooms :: [Classroom] -> [Classroom]
resetClassrooms = map clearRoomSchedule

-- | Função do terminal para escolher um dia e horário para uma turma.
pickDayClass :: IO (Weekday, Int)
pickDayClass = do
    setSGR [SetColor Foreground Dull Blue]
    putStrLn "Escolha o dia da semana:"
    setSGR [Reset]
    putStrLn "[1] Segunda   [2] Terça   [3] Quarta   [4] Quinta   [5] Sexta"
    hFlush stdout
    diaStr <- getLine
    let weeknd = parseSchedule diaStr
    pickHour weeknd

    where
 pickHour :: Weekday -> IO (Weekday, Int)
 pickHour dia = do
        setSGR [SetColor Foreground Dull Blue]
        putStrLn $ "\nEscolha o horário para " ++ show dia ++ ":"
        setSGR [Reset]
        putStrLn "[1] 08:00 - 10:00   [2] 10:00 - 12:00   [3] 14:00 - 16:00\n[4] 16:00 - 18:00   [5] 18:00 - 20:00   [6] 20:00 - 22:00"
        hFlush stdout
        horaStr <- getLine
        case readMaybe horaStr of
            Just h | h >= 1 && h <= 6 -> return (dia, h)
            _ -> do
                putStrLn "Horário inválido. Tente novamente."
                pickHour dia
