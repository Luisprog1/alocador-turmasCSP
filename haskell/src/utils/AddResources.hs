module Utils.AddResources where
import Tipos
import Data.Char (toLower)

-- | Função auxiliar para converter uma string em um recurso. Funciona para a entrada do usuário quando ele digita os recursos (String) e precisa ser convertida para o tipo Resource.
-- | Funciona para Salas e Turmas.
parseResource :: String -> Resource
parseResource str = case map toLower str of
  "projetor"     -> Projector
  "laboratorio"    -> Laboratory
  "acessibilidade"  -> Acessibility
  "quadro branco" -> Whiteboard
  _ -> error ("Recurso inexistente")