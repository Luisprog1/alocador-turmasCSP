module Tipos where
import qualified Data.Map as Map

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

data Weekend = Monday | Tuesday | Wednesday | Thursday | Friday deriving (Show, Eq, Read, Ord)
type ScheduleMap = Map.Map Weekend [Int]
