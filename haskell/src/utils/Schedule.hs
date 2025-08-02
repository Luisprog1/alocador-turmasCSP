module Utils.Schedule where
import qualified Data.Map as Map
import Data.List (sort, nub)
import Tipos 

-- | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
scheduleContains :: ScheduleMap -> Weekend -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | Retorna True se um tipo ScheduleMap contem 1 ou mais par ordenado (dia da semana, horario).
isAnyOccupation :: Classroom -> Class -> Bool
isAnyOccupation classroom clss = 
    any (\(day, hour) -> scheduleContains (roomSchedule classroom) day hour) (schedule clss)


addSlotsToSchedule :: [(Weekend, Int)] -> ScheduleMap -> ScheduleMap
addSlotsToSchedule [] currentSchedule = currentSchedule -- Base case: lista de slots vazia
addSlotsToSchedule ((day, hour):restOfSchedule) currentSchedule =
    let
        currHoursForDay = Map.findWithDefault [] day currentSchedule
        updatedHoursForDay = sort . nub $ currHoursForDay ++ [hour]
        scheduleAfterThisSlot = Map.insert day updatedHoursForDay currentSchedule
    in
        addSlotsToSchedule restOfSchedule scheduleAfterThisSlot


addOccupationOnClassroom :: Class -> Classroom -> Classroom
addOccupationOnClassroom clss classroom 
    | isAnyOccupation classroom clss = classroom
    | otherwise =
        
            classroom { roomSchedule = addSlotsToSchedule (schedule clss) (roomSchedule classroom) }

-- | Passa a escolha da entrada para um dia do tipo Weekend.
-- | Dica: coloquei números porque pode ser um menu de opcoes. 
parseSchedule :: String -> Weekend
parseSchedule str = case str of
  "1" -> Monday
  "2" -> Tuesday
  "3" -> Wednesday
  "4" -> Thursday
  "5" -> Friday
  _   -> error "Invalid day string"

-- | com base na entrada convertida do dia  e o horario da aula, cria uma tupla. !!
-- | Sugestão: adicionar essas horas na turma com a funcao addSlotToClass
createHour :: Weekend -> Int -> (Weekend, Int)
createHour day hour = (day, hour)

addSlotToClass :: Class -> (Weekend, Int) -> Class
addSlotToClass clss (day, hour) 
    | elem (day, hour) (schedule clss) = clss
    | otherwise = 
        clss {schedule = schedule clss ++ [(day,hour)]}