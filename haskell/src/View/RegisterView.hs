{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
module View.RegisterView where

import Repository.UserRepository (User(..), registerUser, loginUser, getUsers, saveAllUsers)
import System.IO
import View.UI
import Repository.ClassRepository (getClass, saveAllClasses)
import Repository.ClassroomRepository (getClassroom, saveAllClassrooms)
import Repository.AlocateRepository (getAllocs, saveAllocs)
import View.AdminView (adminMenu)
import View.ProfessorView 
import Utils.Error (printError)

-- | Tipos de entrada possíveis para o sistema
data InputType = Tipo | Matricula | Senha

-- | Tela inicial que permite ao usuário escolher entre registrar ou fazer login
userScreen :: IO ()
userScreen = do
    drawHeader "BEM-VINDO AO SISTEMA"
    putStrLn "1 - Registrar"
    putStrLn "2 - Login"
    option <- readLine " "
    case option of
        "1" -> registerScreen
        "2" -> loginScreen
        _   -> retryError "Opção inválida!" userScreen

-- | Solicita entrada do usuário de acordo com o tipo (Tipo, Matrícula ou Senha)
-- * Senha: entrada de senha com máscara
askInput :: InputType -> String -> IO String
askInput Senha prompt = do
    putStr prompt
    hFlush stdout
    readPassword
askInput _ prompt = do
    putStr prompt
    hFlush stdout
    getLine

-- | Valida o valor inserido com base no tipo de entrada
validate :: InputType -> String -> Bool
validate Tipo      val = val == "0" || val == "1"
validate Matricula val = not (null val) && all (`elem` ['0'..'9']) val
validate Senha     val = not (null val)

-- | Mensagens de erro para cada tipo de entrada inválida
errorMessage :: InputType -> String
errorMessage Tipo      = "Opção inválida. Digite 0 (Administrador) ou 1 (Professor)."
errorMessage Matricula = "Matrícula inválida. Digite apenas números."
errorMessage Senha     = "Senha não pode ser vazia."

-- | Exibe uma mensagem e pausa (usado para SUCESSO/INFO).
retry :: String -> IO a -> IO a
retry message action = do
    putStrLn message
    putStrLn "\nPressione Enter para continuar..."
    _ <- getLine
    action

-- | Exibe uma mensagem de ERRO em vermelho e pausa (usa printError).
retryError :: String -> IO a -> IO a
retryError message action = do
    printError message
    action

-- | Tela de registro que redireciona para o fluxo de Administrador ou Professor
registerScreen :: IO ()
registerScreen = do
    drawHeader "CADASTRO DE USUÁRIO"
    tipo <- askInput Tipo "Selecione o tipo:\n[1] Professor [0] Administrador \n"
    if validate Tipo tipo
        then case tipo of
            "0" -> registerAdmin
            "1" -> registerProfessor
            _   -> retryError (errorMessage Tipo) registerScreen
        else retryError (errorMessage Tipo) registerScreen

-- | Fluxo de registro para Administrador
registerAdmin :: IO ()
registerAdmin = do
    matricula <- askInput Matricula "Matrícula: "
    if not (validate Matricula matricula)
        then retryError (errorMessage Matricula) registerAdmin
        else do
            senha     <- askInput Senha "Senha: "
            if not (validate Senha senha)
                then retryError (errorMessage Senha) registerAdmin
                else do
                    senhaConf <- askInput Senha "Confirme a senha: "
                    if not (validate Senha senhaConf)
                        then retryError (errorMessage Senha) registerAdmin
                        else do
                            resultado <- registerUser 0 (read matricula) "ADMIN" senha senhaConf
                            if resultado
                                then retry "Administrador registrado com sucesso!" userScreen
                                else retry "Administrador não cadastrado! Voltando para tela inicial..." userScreen

-- | Fluxo de registro para Professor
registerProfessor :: IO ()
registerProfessor = do
    matricula <- askInput Matricula "Informe sua matrícula: "
    if not (validate Matricula matricula)
        then retryError (errorMessage Matricula) registerProfessor
        else do
            users <- getUsers
            let matriculaInt = read matricula :: Int
                profs = filter (\u -> userTipo u == 1 && userMatricula u == matriculaInt) users
            case profs of
                [] -> retryError "Matrícula não encontrada! Peça para o administrador cadastrá-lo primeiro." userScreen
                [User _ m nome senha]
                    | null senha -> setNewPassword users m nome
                    | otherwise  -> retry "Essa matrícula já possui senha. Faça login normalmente." userScreen
                _ -> retryError "Erro inesperado no cadastro." userScreen

-- | Permite ao Professor cadastrar uma nova senha
-- * users: lista de usuários atuais
-- * matricula: matrícula do professor
-- * nome: nome do professor
setNewPassword :: [User] -> Int -> String -> IO ()
setNewPassword users matricula nome = do
    putStrLn $ "Bem-vindo, " ++ nome ++ "! Cadastre sua nova senha:"
    novaSenha <- askInput Senha "Nova senha: "
    if not (validate Senha novaSenha)
        then retryError (errorMessage Senha) (setNewPassword users matricula nome)
        else do
            confSenha <- askInput Senha "Confirme a nova senha: "
            if novaSenha == confSenha
                then do
                    let usersAtualizados = map (\u ->
                            if userMatricula u == matricula
                                then u { userSenha = novaSenha }
                                else u) users
                    saveAllUsers usersAtualizados
                    retry "Senha cadastrada com sucesso! Agora faça login normalmente." userScreen
                else retryError "Senhas não conferem!" registerProfessor

-- | Tela de login: verifica tipo de usuário e redireciona
loginScreen :: IO ()
loginScreen = do
    drawHeader "SISTEMA DE LOGIN"
    matricula <- askInput Matricula "Matrícula: "
    if not (validate Matricula matricula)
        then retryError (errorMessage Matricula) loginScreen
        else do
            senha <- askInput Senha "Senha: "
            if not (validate Senha senha)
                then retryError (errorMessage Senha) loginScreen
                else do
                    tipoUsuario <- loginUser (read matricula) senha
                    case tipoUsuario of
                        Just 0 -> do
                            putStrLn "Carregando tela do administrador..."
                            classes <- getClass
                            classrooms <- getClassroom
                            (classes', classrooms') <- adminMenu 0 classes classrooms
                            saveAllClasses classes'
                            saveAllClassrooms classrooms'
                            userScreen
                        Just 1 -> do
                            putStrLn "Carregando turmas..."
                            classes <- getClass
                            classes' <- professorMenu classes (read matricula)
                            saveAllClasses classes'
                            userScreen
                        Nothing ->
                            retryError "Matrícula ou senha incorretos!" userScreen

-- | Lê senha mascarando caracteres
readPassword :: IO String
readPassword = do
    hSetBuffering stdin NoBuffering
    hSetBuffering stdout NoBuffering
    hSetEcho stdin False
    senha <- loop ""
    putStrLn ""
    hSetBuffering stdin LineBuffering
    hSetBuffering stdout LineBuffering
    hSetEcho stdin True
    return senha
  where
    loop acc = do
      c <- getChar
      case c of
        '\n'   -> return acc
        '\DEL' -> backspace acc
        '\BS'  -> backspace acc
        _      -> putChar '*' >> loop (acc ++ [c])

    backspace acc
      | null acc  = loop acc
      | otherwise = putStr "\b \b" >> loop (init acc)
