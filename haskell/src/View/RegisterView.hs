module View.RegisterView where

import Repository.UserRepository (registerUser, loginUser)
import System.IO (hFlush, stdout, hSetEcho, hSetBuffering, BufferMode(NoBuffering, LineBuffering), stdin)
import View.UI (drawHeader)

-- Tipos de entrada possíveis
data InputType = Tipo | Matricula | Senha

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

-- Função genérica para pedir entradas com validação
askInput :: InputType -> String -> IO String
askInput inputType prompt = do
    putStr prompt
    hFlush stdout
    valor <- case inputType of
        Senha     -> lerSenha
        _         -> getLine
    if isValid inputType valor
        then return valor
        else do
            putStrLn (msgErro inputType)
            askInput inputType prompt
  where
    -- Validação de acordo com o tipo
    isValid Tipo val      = val == "0" || val == "1"
    isValid Matricula val = not (null val) && all (`elem` ['0'..'9']) val
    isValid Senha val     = not (null val)

    -- Mensagens de erro
    msgErro Tipo      = "Opção inválida. Digite 0 para Administrador ou 1 para Professor."
    msgErro Matricula = "Matrícula inválida. Digite apenas números e não deixe em branco."
    msgErro Senha     = "Senha não pode ser vazia."

-- Tela de registro
register_screen :: IO ()
register_screen = do
    drawHeader "CADASTRO DE USUÁRIO"
    tipoStr      <- askInput Tipo "Selecione o tipo:\n[1] Professor [0] Administrador \n"
    matriculaStr <- askInput Matricula "Matrícula: "
    senha        <- askInput Senha "Senha: "
    senhaConf    <- askInput Senha "Confirme a senha: "
    registerUser (read tipoStr) (read matriculaStr) senha senhaConf

-- Tela de login
login_screen :: IO ()
login_screen = do
    drawHeader "SISTEMA DE LOGIN"
    matriculaStr <- askInput Matricula "Matrícula: "
    senha        <- askInput Senha "Senha: "
    loginUser (read matriculaStr) senha
