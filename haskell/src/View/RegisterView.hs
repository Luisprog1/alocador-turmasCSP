module View.RegisterView where

import Repository.UserRepository (registerUser, loginUser)
import System.IO (hFlush, stdout, hSetEcho, hSetBuffering, BufferMode(NoBuffering, LineBuffering), stdin)

-- Função para ler senha ocultando os caracteres (mostra '*')
lerSenha :: IO String
lerSenha = do
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

    backspace acc =
      if null acc
        then loop acc
        else putStr "\b \b" >> loop (init acc)

-- Tela de registro
register_screen :: IO ()
register_screen = do
    putStr "\ESC[2J"
    putStrLn "=================================="
    putStrLn "       Cadastro de Usuário"
    putStrLn "=================================="
    putStrLn "Selecione o tipo de usuário:"
    putStrLn "1 - Professor"
    putStrLn "0 - Administrador"
    tipoStr <- getLine
    let tipo = read tipoStr :: Int
    putStrLn "Por favor, insira seus dados:"
    putStr "Matrícula: "
    hFlush stdout
    matricula <- getLine
    putStr "Senha: "
    senha <- lerSenha
    putStr "Confirmação de Senha: "
    senhaConf <- lerSenha
    registerUser tipo (read matricula) senha senhaConf


-- Tela de login
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
    senha <- lerSenha
    loginUser (read matricula) senha
