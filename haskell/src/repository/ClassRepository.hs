module Repository.ClassRepository (saveClass, getClass) where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)

saveClass :: Class -> IO ()
saveClass clssData = do
    appendFile "src/data/class.txt" (show clssData ++ "\n")

getClass :: IO [Class]
getClass = do
    contents <- readFile "src/data/class.txt"
    let linesOfText = lines contents
    return $ mapMaybe readMaybe linesOfText