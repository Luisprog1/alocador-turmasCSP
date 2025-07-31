module Tipos where
import qualified Data.Map as Map

data Resource = Projector | Laboratory | Acessibility | Other String deriving(Show, Eq, Read)

data Weekend = Monday | Tuesday | Wednesday | Thursday | Friday deriving (Show, Eq, Read, Ord)
type ScheduleMap = Map.Map Weekend [Int]

data Class = Class {  
classId :: Int,
subject :: String,
course :: String,
professor :: String,
schedule :: [(Weekend, Int)],
-- schedule (segunda, 1)
-- scheduleSala [(segunda: 1, 2), (terça: 3)]
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

-- | Retorna True se um tipo ScheduleMap contém um horário em um dia da semana.
scheduleContains :: ScheduleMap -> Weekend -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

-- | Retorna True se um tipo ScheduleMap contém 1 ou mais par ordenado (dia da semana: horário).
allScheduleContains :: ScheduleMap -> Class -> Bool
allScheduleContains scheduleMap clss = 
    all(\(day, hour) -> scheduleContains scheduleMap day hour) (schedule clss)

verifyOccupation :: Classroom  -> Class -> Bool
verifyOccupation classroom clss = 
    allScheduleContains (roomSchedule classroom) schedule clss


addOccupation :: Class -> Classroom -> Classroom
addOccupation clss classroom 
    | verifyOccupation classroom clss = classroom
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
                    -- Adiciona o novo 'hour' à lista e garante que é única e ordenada
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
