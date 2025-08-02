module Schedule where
import qualified Data.Map as Map
import Data.List (sort, nub)
import Tipos 

-- | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
scheduleContains :: ScheduleMap -> Weekend -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | Retorna True se um tipo ScheduleMap contém 1 ou mais par ordenado (dia da semana, horário).
isAnyOccupation :: Classroom -> Class -> Bool
isAnyOccupation classroom clss = 
    any (\(day, hour) -> scheduleContains (roomSchedule classroom) day hour) (schedule clss)

addOccupation :: Class -> Classroom -> Classroom
addOccupation clss classroom 
    | isAnyOccupation classroom clss = classroom
    | otherwise =
         let
            -- Esta é uma função auxiliar interna que faz o trabalho recursivo de adicionar os slots.
            -- Ela itera sobre a lista de (Weekend, Int) da Class.
            addSlotsToSchedule :: [(Weekend, Int)] -> ScheduleMap -> ScheduleMap
            addSlotsToSchedule [] currentSchedule = currentSchedule -- Base case: lista de slots vazia
            addSlotsToSchedule ((day, hour):restOfSchedule) currentSchedule =
                let
                    -- Pega os horários atuais para este 'day' no 'currentSchedule'
                    currHoursForDay = Map.findWithDefault [] day currentSchedule
                    -- Adiciona o novo 'hour' à lista 
                    updatedHoursForDay = sort . nub $ currHoursForDay ++ [hour]
                    -- Insere a lista atualizada de volta no 'currentSchedule'
                    scheduleAfterThisSlot = Map.insert day updatedHoursForDay currentSchedule
                in
                    -- Chama recursivamente para o restante da lista de horários da turma,
                    -- passando o ScheduleMap já atualizado.
                    addSlotsToSchedule restOfSchedule scheduleAfterThisSlot
        in
            -- Chama a função auxiliar com os horários da turma e o ScheduleMap inicial da sala
            classroom { roomSchedule = addSlotsToSchedule (schedule clss) (roomSchedule classroom) }
