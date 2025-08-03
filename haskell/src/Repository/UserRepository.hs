module Repository.UserRepository where

-- Lê todos os usuários salvos no arquivo e retorna uma lista de (matrícula, senha)
getUsers :: IO [(Int, String)]
getUsers = do
    contents <- readFile "src/data/user.txt"
    length contents `seq` return ()  -- garante que o arquivo será fechado
    let linhas = lines contents
    return $ map (\linha -> let (idStr, senha) = break (== ' ') linha
                            in (read idStr, drop 1 senha)) linhas

-- Sobrescreve o arquivo com a lista de usuários
saveAllUsers :: [(Int, String)] -> IO ()
saveAllUsers users =
    writeFile "src/data/user.txt" $
        unlines (map (\(idU, senha) -> show idU ++ " " ++ senha) users)

-- Registra um novo usuário (adiciona na lista existente)
register_User :: Int -> String -> String -> IO ()
register_User matricula senha senhaConf =
    if senha == senhaConf
        then do
            users <- getUsers
            let newUsers = users ++ [(matricula, senha)]
            saveAllUsers newUsers
            putStrLn "Usuário registrado com sucesso!"
        else
            putStrLn "Senhas não conferem!"

-- Realiza login verificando matrícula e senha na lista de usuários
login_User :: Int -> String -> IO ()
login_User matricula senha = do
    users <- getUsers
    let encontrado = any (\(mat, pass) -> mat == matricula && pass == senha) users
    if encontrado
        then putStrLn "Login realizado com sucesso!"
        else putStrLn "Matrícula ou senha incorretos!"
