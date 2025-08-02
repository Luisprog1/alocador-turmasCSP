module Alocador where
import Utils.Schedule 
import Tipos


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
        allocClassroomId = (classroomId classroom) 
    }