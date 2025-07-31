module View.Register () where
import Repository.UserRepository
import System.IO (hFlush, stdout)
 
register_screen :: IO ()
register_screen = do
    putStr "\ESC[2J"

    putStrLn "=================================="
    putStrLn "       Cadastro de Usuário"
    putStrLn "=================================="
    putStrLn "Por favor, insira seus dados:"
    putStr "Matrícula: "
    hFlush stdout
    matricula <- getLine
    putStr "Senha: "
    hFlush stdout
    senha <- getLine
    putStr "Confirmação de Senha: "
    hFlush stdout
    senhaConf <- getLine
    register_User (read matricula) senha senhaConf

login_screen :: IO ()
login_screen = do
    putStr "\ESC[2J"

    putStrLn "=================================="
    putStrLn "               Login"
    putStrLn "=================================="
    putStrLn "Por favor, insira seus dados:"
    putStr "Matrícula: "
    hFlush stdout
    matricula <- getLine
    putStr "Senha: "
    hFlush stdout
    senha <- getLine
    login_User (read matricula) senha
