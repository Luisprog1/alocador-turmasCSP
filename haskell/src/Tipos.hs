module Tipos where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
-- Tipos de ID para clareza e segurança de tipo
newtype ClassroomId = SalaId Int deriving (Show, Eq, Ord, Generic, ToJSON, FromJSON)
newtype ClassId = TurmaId Int deriving (Show, Eq, Ord, Generic, ToJSON, FromJSON)


data Resource = Projector | Laboratory | Acessibility | Other String

data Class = Class {  
classId :: ClassId,
subject :: String,
course :: String,
professor :: String,
schedule :: String,
size :: Int,
requirements :: [Resource]
} deriving ()

data Classroom = Classroom { 
classroomId :: ClassroomId,
capacity :: Int,
block :: String,
resources :: [Resource]
} deriving ()

data Allocation = Allocation { 
allocationId :: Int, 
allocClassId :: ClassId,
allocClassroomId :: ClassroomId
}