module Tipos where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

data Resource = Projector | Laboratory | Acessibility | Other String

data Class = Class {  
classId :: Int,
subject :: String,
course :: String,
professor :: String,
schedule :: String,
size :: Int,
requirements :: [Resource]
}

data Classroom = Classroom { 
classroomId :: Int,
capacity :: Int,
block :: String,
resources :: [Resource]
}

data Allocation = Allocation { 
allocationId :: Int, 
allocClassId :: Int,
allocClassroomId :: Int
}