module Repository.UserRepository where

import Data.List.Split (splitOn)

-- Módulo responsável apenas por dados: CRUD de usuários

-- | Representa um usuário do sistema
data User = User
  { userTipo      :: Int      -- 0 = admin, 1 = professor
  , userMatricula :: Int
  , userNome      :: String
  , userSenha     :: String
  } deriving (Show, Eq)

-- -----------------------------
-- Funções de persistência
-- -----------------------------

-- | Lê todos os usuários do arquivo 'user.txt'
getUsers :: IO [User]
getUsers = do
    contents <- readFile "src/data/user.txt"
    if null contents
        then return []  -- arquivo totalmente vazio
        else do
            let linhas = filter (not . null) (lines contents)  -- ignora linhas vazias
            return $ map parseUser linhas

-- | Converte uma linha do arquivo em um 'User'
parseUser :: String -> User
parseUser linha =
    case splitOn ";" linha of
        [tipoStr, matStr, nome, senha] ->
            User (read tipoStr) (read matStr) nome senha
        [tipoStr, matStr, nome] ->
            User (read tipoStr) (read matStr) nome ""   -- senha vazia
        _ -> error ("Linha mal formatada em user.txt: " ++ linha)

-- | Salva todos os usuários sobrescrevendo o arquivo 'user.txt'
saveAllUsers :: [User] -> IO ()
saveAllUsers users =
    writeFile "src/data/user.txt" $
        unlines (map serializeUser users)

-- | Converte um 'User' para string para salvar no arquivo
serializeUser :: User -> String
serializeUser (User tipo mat nome senha)
    | null senha = show tipo ++ ";" ++ show mat ++ ";" ++ nome
    | otherwise  = show tipo ++ ";" ++ show mat ++ ";" ++ nome ++ ";" ++ senha

-- -----------------------------
-- Funções de negócio
-- -----------------------------

-- | Registra um novo usuário (Administrador ou Professor)
-- Retorna True se sucesso, False se erro ou já existir admin
registerUser :: Int -> Int -> String -> String -> String -> IO Bool
registerUser tipo matricula _ senha senhaConf = do
    users <- getUsers
    if senha /= senhaConf
        then do
            putStrLn "Senhas não conferem!"
            return False
        else case tipo of
            0 -> registerAdmin users matricula senha
            1 -> registerProfessor users matricula senha
            _ -> do
                putStrLn "Tipo inválido!"
                return False

-- | Registra um administrador (se não existir outro)
-- | Retorna True se cadastro bem-sucedido, False se admin já existe
registerAdmin :: [User] -> Int -> String -> IO Bool
registerAdmin users matricula senha =
    if null users || not (any (\u -> userTipo u == 0) users)
        then do
            let newUsers = users ++ [User 0 matricula "ADMIN" senha]
            saveAllUsers newUsers
            return True
        else do
            return False

-- | Registra senha de professor existente (primeiro login)
-- Retorna True se sucesso, False se matrícula não encontrada ou senha já cadastrada
registerProfessor :: [User] -> Int -> String -> IO Bool
registerProfessor users matricula senha =
    case filter (\u -> userMatricula u == matricula) users of
        [] -> do
            putStrLn "Matrícula não encontrada! Peça para o administrador adicioná-lo à lista de professores."
            return False
        [professor]
            | null (userSenha professor) -> do
                let usersAtualizados = map
                        (\u -> if userMatricula u == matricula
                               then u { userSenha = senha }
                               else u)
                        users
                saveAllUsers usersAtualizados
                putStrLn $ "Senha cadastrada com sucesso para " ++ userNome professor ++ "!"
                putStrLn "\nPressione Enter para continuar..."
                _ <- getLine
                return True
            | otherwise -> do
                putStrLn "Essa matrícula já possui senha. Faça login normalmente."
                return False
        _ -> do
            putStrLn "Erro inesperado: múltiplos usuários encontrados."
            return False

-- | Faz login e retorna o tipo do usuário (0 = admin, 1 = professor)
loginUser :: Int -> String -> IO (Maybe Int)
loginUser matricula senha = do
    users <- getUsers
    let encontrado = filter (\u -> userMatricula u == matricula && userSenha u == senha) users
    case encontrado of
        [User tipo _ _ _] -> return (Just tipo)
        _                 -> return Nothing
