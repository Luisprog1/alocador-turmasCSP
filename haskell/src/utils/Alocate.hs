module Utils.Alocate where

import Utils.Schedule 
import Tipos
import Data.List as List
import Data.Map as Map


checkResources :: Eq a => [a] -> [a] -> Bool
checkResources requisitos recursos = all (\x -> elem x requisitos) recursos

allocateClass :: Class -> Classroom -> Bool
allocateClass clss classroom 
    | checkResources (requirements clss) (resources classroom)
      && (quantity clss <= capacity classroom)
      && not (isAnyOccupation classroom clss) = True
    | otherwise = False 

createAllocation :: Class -> Classroom -> Allocation
createAllocation clss classroom =
    Allocation { 
        allocationId = 1, 
        allocClassId = (classId clss),
        allocClassroomCode = (classroomCode classroom) 
    }

type AllocationSolution = Maybe [Allocation]

backtrackAllocate :: [Class] -> [Classroom] -> AllocationSolution
-- | Caso base: Se não há mais turmas para alocar, encontramos uma solução.
backtrackAllocate [] _ = Just []
backtrackAllocate (clss:restClasses) classrooms =
    List.foldr (\classroom acc ->
        if allocateClass clss classroom
        then
            -- | A alocação foi possível. Criamos uma nova lista de salas atualizada.
            -- | Usamos 'Map.unionWith' para combinar as agendas de forma correta,
            -- | concatenando as listas de horários para o mesmo dia.
            let newSchedule = Map.fromListWith (++) (List.map (\(day, hour) -> (day, [hour])) (schedule clss))
                updatedClassroom = classroom {
                    roomSchedule = Map.unionWith (++) (roomSchedule classroom) newSchedule
                }
                -- | Removemos a sala antiga e adicionamos a sala atualizada.
                remainingRooms = updatedClassroom : (classrooms List.\\ [classroom])
                subAllocation = backtrackAllocate restClasses remainingRooms
            in
            -- | Se a sub-alocação retornou uma solução, a adicionamos à solução atual.
            case subAllocation of
                Just subAlloc -> Just (createAllocation clss classroom : subAlloc)
                Nothing -> acc
        else
            acc
    ) Nothing classrooms
    where
        -- | Esta função cria um objeto 'Allocation' como na sua imagem.
        createAllocation :: Class -> Classroom -> Allocation
        createAllocation clss classroom =
            Allocation {
                allocationId = 1, -- Ou use um ID gerado dinamicamente
                allocClassId = classId clss,
                allocClassroomCode = classroomCode classroom
            }