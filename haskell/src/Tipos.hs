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
schedule :: String,
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

scheduleContains :: ScheduleMap -> Weekend -> Int -> Bool
scheduleContains scheduleMap day hour = 
    case Map.lookup day scheduleMap of
        Just hours -> hour `elem` hours
        Nothing -> False

verifyOccupation :: Classroom  -> Weekend -> Int -> Bool
verifyOccupation classroom day hour = scheduleContains (roomSchedule classroom) day hour


addOccupation :: Weekend -> Int -> Classroom -> Classroom
addOccupation day hour classroom 
    | hour < 1 || hour > 6 = classroom
    | verifyOccupation classroom day hour = classroom
    | otherwise =
        let 
            currHours = Map.findWithDefault [] day (roomSchedule classroom)
            updatedHours = currHours ++ [hour]
            updatedSchedule = Map.insert day updatedHours (roomSchedule classroom)
        in 
            classroom { roomSchedule = updatedSchedule }
