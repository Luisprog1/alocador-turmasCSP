module Repository.UserRepository where
import View.ProfessorView (welcome_screen)
import Repository.ClassRepository

-- Lê todos os usuários: tipo (0/1), matrícula e senha
getUsers :: IO [(Int, Int, String)]
getUsers = do
    contents <- readFile "src/data/user.txt"
    length contents `seq` return ()
    let linhas = lines contents
    return $ map (\linha ->
        let [tipoStr, matStr, senha] = words linha
        in (read tipoStr, read matStr, senha)
      ) linhas

-- Salva todos os usuários no arquivo
saveAllUsers :: [(Int, Int, String)] -> IO ()
saveAllUsers users =
    writeFile "src/data/user.txt" $
        unlines (map (\(tipo, idU, senha) -> show tipo ++ " " ++ show idU ++ " " ++ senha) users)

-- Registra novo usuário, impedindo mais de um admin
registerUser :: Int -> Int -> String -> String -> IO ()
registerUser tipo matricula senha senhaConf =
    if senha == senhaConf
        then do
            users <- getUsers
            -- Verifica se já existe um admin
            if tipo == 0 && any (\(t,_,_) -> t == 0) users
                then putStrLn "Já existe um administrador cadastrado!"
                else do
                    let newUsers = users ++ [(tipo, matricula, senha)]
                    saveAllUsers newUsers
                    putStrLn "Usuário registrado com sucesso!"
        else
            putStrLn "Senhas não conferem!"

-- Login: retorna tipo de usuário ou erro
loginUser :: Int -> String -> IO ()
loginUser matricula senha = do
    users <- getUsers
    let encontrado = filter (\(_, mat, pass) -> mat == matricula && pass == senha) users
    case encontrado of
        [(tipo, _, _)] ->
            if tipo == 1
                then do
                    clss <- getClass
                    putStrLn "Carregando turmas..."
                    clss' <- welcome_screen clss
                    saveAllClasses clss'
                    return ()
                else putStrLn "TELA DE ADMINISTRADOR"
        _ -> putStrLn "Matrícula ou senha incorretos!"
