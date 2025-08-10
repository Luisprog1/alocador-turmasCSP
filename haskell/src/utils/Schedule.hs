module Utils.Schedule where
import qualified Data.Map as Map
import Data.List (sort, nub)
import Tipos 
import Text.Read (readMaybe)
import System.IO (hFlush, stdout)
import System.Console.ANSI


-- | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
--
-- * scheduleMap: mapa de agendamento
-- * day: dia da semana
-- * hour: horário a ser verificado
scheduleContains :: ScheduleMap -> Weekday -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | Retorna True se uma sala contém 1 ou mais par ordenado (dia da semana, horario) da turma.
--
-- * classroom: sala de aula
-- * clss: turma a ser verificada
isAnyOccupation :: Classroom -> Class -> Bool
isAnyOccupation classroom clss = 
    any (\(day, hour) -> scheduleContains (roomSchedule classroom) day hour) (schedule clss)

-- | Adiciona uma ocupação de horário da turma na sala.
--
-- * clss: turma a ser alocada
-- * classroom: sala onde a turma será alocada
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

-- | Passa a escolha da entrada para um dia do tipo Weekday.
parseSchedule :: String -> Weekday
parseSchedule str = case str of
  "1" -> Segunda
  "2" -> Terca
  "3" -> Quarta
  "4" -> Quinta
  "5" -> Sexta
  _   -> error "Invalid day string"

-- | Adiciona uma lista de horários à turma.
--
-- * clss: turma a ser atualizada
-- * slots: lista de horários a serem adicionados
addSlotToClass :: Class -> [(Weekday, Int)] -> Class
addSlotToClass clss slots = clss {schedule = nub (schedule clss ++ slots)}

-- | Remove um horário específico da turma.
--
-- * clss: turma a ser atualizada
-- * slot: horário a ser removido
removeSlotFromClass :: Class -> (Weekday, Int) -> Class
removeSlotFromClass clss slot = clss {schedule = filter (/= slot) (schedule clss)}

-- | Limpa o agendamento de uma única sala de aula.
clearRoomSchedule :: Classroom -> Classroom
clearRoomSchedule room = room {
    roomSchedule = Map.empty 
}

-- | Aplica a limpeza do agendamento em todas as salas da lista.
resetClassrooms :: [Classroom] -> [Classroom]
resetClassrooms = map clearRoomSchedule

-- | Lê um dia da semana para criar um mapeamento de horário.
readDay :: IO Weekday
readDay = do
    putStrLn "Escolha o dia (ou pressione Enter para finalizar):"
    putStrLn "[1] Segunda   [2] Terça   [3] Quarta   [4] Quinta   [5] Sexta"
    hFlush stdout
    day <- getLine
    if null day
        then return None
        else return (parseSchedule day)

-- | Lê um horário para criar um mapeamento de horário.
readHour :: IO Int
readHour = do
    putStrLn "Escolha o horário:"
    putStrLn "[1] 08:00 - 10:00   [2] 10:00 - 12:00   [3] 14:00 - 16:00\n[4] 16:00 - 18:00   [5] 18:00 - 20:00   [6] 20:00 - 22:00"
    hFlush stdout
    hour <- getLine
    case readMaybe hour of
        Just h -> return h
        Just h | h < 1 || h > 6 -> do
            putStrLn "Horário inválido. Tente novamente."
            readHour
        Nothing -> do
            putStrLn "Horário inválido. Tente novamente."
            readHour

-- | Chama a leitura do agendamento.
readSchedule :: [(Weekday, Int)] -> IO [(Weekday, Int)]
readSchedule schedule = do
    day <- readDay
    if day == None
        then return schedule
        else do
            let weekday = day
            hour <- readHour
            readSchedule (nub (schedule ++ [(weekday, hour)]))