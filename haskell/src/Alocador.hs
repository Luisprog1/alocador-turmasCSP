module Alocador where

import Tipos 

satisfiesRequirements :: Eq Resource => [Resource] -> [Resource] -> Bool
satisfiesRequirements turma sala = all (\has -> elem has turma) (turma)