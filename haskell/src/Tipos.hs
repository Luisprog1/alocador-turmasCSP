module Tipos where
import qualified Data.Map as Map
import Data.List (sort, nub)

data Resource = Projector | Laboratory | Acessibility | Other String deriving(Show, Eq, Read)

data Class = Class {  
classId :: Int,
subject :: String,
course :: String,
professor :: String,
schedule :: [(Weekend, Int)],
quantity :: Int,
requirements :: [Resource]
} deriving (Show, Eq, Read)

data Classroom = Classroom { 
classroomId :: Int,
capacity :: Int,
block :: String,
resources :: [Resource],
roomSchedule :: ScheduleMap
} deriving (Show, Eq, Read)

data Allocation = Allocation { 
allocationId :: Int, 
allocClassId :: Int,
allocClassroomId :: Int
}


-- | TODOS OS DADOS E FUNÇÕES DA RESTRIÇÃO HORARIO.
data Weekend = Monday | Tuesday | Wednesday | Thursday | Friday deriving (Show, Eq, Read, Ord)
type ScheduleMap = Map.Map Weekend [Int]

-- | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
scheduleContains :: ScheduleMap -> Weekend -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | Retorna True se um tipo ScheduleMap contém 1 ou mais par ordenado (dia da semana: horário).
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
