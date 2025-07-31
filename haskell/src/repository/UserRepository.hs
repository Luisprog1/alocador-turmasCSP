module Repository.UserRepository (saveUser, register_User, login_User) where

saveUser :: Int -> String -> IO ()
saveUser matricula pass = do
    writeFile "src/data/user.txt" (show matricula ++ " " ++ pass)

register_User :: Int -> String -> String -> IO ()
register_User matricula pass senhaConf = do
    if pass == senhaConf
        then do
            saveUser matricula pass
            putStrLn "User registered successfully!"
        else
            putStrLn "Passwords do not match!"


login_User :: Int -> String -> IO ()
login_User matricula pass = do
    content <- readFile "src/data/user.txt"
    let (m, p) = break (== ' ') content
    if show matricula == m && pass == tail p
        then putStrLn "Login successful!"
        else putStrLn "Login failed!"

