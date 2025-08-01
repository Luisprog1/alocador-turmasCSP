module Repository.ClassRepository where

import Tipos
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.IO (writeFile)
import Data.List (intercalate)
import Data.Char (toLower)

saveClass :: [Class] -> Class -> [Class]
saveClass clssData newClass = clssData ++ [newClass]
    
--saveClasses :: [Class] -> IO ()
--saveClasses clssData = do
    --writeFile "src/data/class.txt" (show clssData ++ "\n")
    
saveAllClasses :: [Class] -> IO ()
saveAllClasses classes = do
    writeFile "src/data/class.txt" (intercalate "\n" (map show classes))

getClass :: IO [Class]
getClass = do
    contents <- readFile "src/data/class.txt"
    let linesOfText = lines contents
    return $ mapMaybe readMaybe linesOfText

parseResource :: String -> Resource
parseResource str = case map toLower str of
  "projector"     -> Projector
  "laboratory"    -> Laboratory
  "acessibility"  -> Acessibility
  _ -> Other str