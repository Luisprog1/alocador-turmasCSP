module Repository.UserRepository where

register_User :: Int -> String -> IO ()
register_User matricula pass = do
    putStrLn $ "matricula: " ++ show matricula ++ " password: " ++ pass
    writeFile "src/data/user.txt" (show matricula ++ " " ++ pass)
login_User :: Int -> String -> IO ()
login_User matricula pass = do
    content <- readFile "src/data/user.txt"
    let (m, p) = break (== ' ') content
    if show matricula == m && pass == tail p
        then putStrLn "Login successful!"
        else putStrLn "Login failed!"

