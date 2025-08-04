module Repository.UserRepository where

import View.ProfessorView (welcome_screen)
import Repository.ClassRepository

-- | Lê todos os usuários do arquivo no formato (tipo, matrícula, senha)
-- | tipo: 0 = Administrador, 1 = Professor
getUsers :: IO [(Int, Int, String)]
getUsers = do
    contents <- readFile "src/data/user.txt"
    length contents `seq` return ()
    let linhas = lines contents
    return $ map (\linha ->
        let [tipoStr, matStr, senha] = words linha
        in (read tipoStr, read matStr, senha)
      ) linhas

-- | Sobrescreve o arquivo com a lista de usuários
saveAllUsers :: [(Int, Int, String)] -> IO ()
saveAllUsers users =
    writeFile "src/data/user.txt" $
        unlines (map (\(tipo, idU, senha) -> show tipo ++ " " ++ show idU ++ " " ++ senha) users)

-- | Registra novo usuário; impede mais de um administrador no sistema
registerUser :: Int -> Int -> String -> String -> IO ()
registerUser tipo matricula senha senhaConf =
    if senha == senhaConf
        then do
            users <- getUsers
            if tipo == 0 && any (\(t,_,_) -> t == 0) users
                then putStrLn "Já existe um administrador cadastrado!"
                else do
                    let newUsers = users ++ [(tipo, matricula, senha)]
                    saveAllUsers newUsers
                    putStrLn "Usuário registrado com sucesso!"
                    -- | Após registrar, já efetua login automático
                    loginUser matricula senha
        else
            putStrLn "Senhas não conferem!"

-- | Faz login: chama tela do professor ou do administrador conforme o tipo
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
                else do
                    putStrLn "Carregando tela do administrador..."
                    -- | Aqui chamaria a tela do administrador
                    putStrLn "TELA DE ADMINISTRADOR"
        _ -> putStrLn "Matrícula ou senha incorretos!"
