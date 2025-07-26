module Tipos where

data Resource = Projector | Laboratory | Acessibility | Other String deriving(Show, Eq)

data Class = Class {  
classId :: Int,
subject :: String,
course :: String,
professor :: String,
schedule :: String,
size :: Int,
requirements :: [Resource]
} deriving (Show, Eq)

data Classroom = Classroom { 
classroomId :: Int,
capacity :: Int,
block :: String,
resources :: [Resource]
} deriving (Show, Eq)

data Allocation = Allocation { 
allocationId :: Int, 
allocClassId :: Int,
allocClassroomId :: Int
}