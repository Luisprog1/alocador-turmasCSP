# Alocador de Turmas

![Status](https://img.shields.io/badge/status-concluido-green) ![License](https://img.shields.io/badge/license-MIT-green)

---

## Sumário

- [Descrição](#descrição)
- [Funcionalidades](#funcionalidades)
- [Fluxo de Uso](#fluxo-de-uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Objetivo](#objetivo)
- [Implementações](#implementações)

---

## Descrição

O **Alocador de Turmas** é um sistema para **alocação automatizada de turmas em salas**.  
Cada turma é representada por um professor, e o sistema garante que **restrições de horário, capacidade e requisitos** sejam respeitadas, oferecendo **ajustes manuais** e visualizações organizadas para administradores e professores.

---

## Funcionalidades

### Acesso e Perfis
- Login e cadastro com **matrícula e senha**.
- Perfis diferenciados para **Administrador** e **Professor**.

### Administrador
- Cadastro e edição de salas e turmas.
- Geração **automática de alocações** considerando restrições.
- Visualização e ajustes das alocações.

### Professor
- Visualização de turmas e alocações atribuídas.
- Edição de **requisitos específicos** das turmas.

### Validação de Conflitos
- Conflitos detectados automaticamente:
  - **Horários** (sobreposição de aulas)
  - **Capacidade** (excedente de alunos por sala)
  - **Requisitos** (necessidades não atendidas)

### Persistência
- Armazenamento e recuperação de dados para manter histórico e consistência.

---

## Fluxo de Uso

1. **Login ou Cadastro**  
   Usuário entra no sistema com matrícula e senha ou cria nova conta.

2. **Gestão de Alocações (Administrador)**  
   - Cadastra salas e turmas.  
   - Gera alocações automaticamente ou faz ajustes manuais.  

3. **Consulta e Edição (Professor)**  
   - Visualiza turmas e alocações atribuídas.  
   - Altera requisitos das suas turmas, se necessário.  

4. **Validação**  
   - O sistema verifica conflitos de horários, capacidade ou requisitos.  

---

## Estrutura do Projeto

- **Interface de Login e Cadastro**
- **Painel do Administrador**  
  Gestão de salas, turmas e alocações
- **Painel do Professor**  
  Visualização e ajustes de turmas/alocações

---

## Objetivo

Oferecer uma solução eficiente para instituições acadêmicas que necessitam **alocar turmas em salas que atendam seus requisitos e capacidades**, reduzindo erros manuais e otimizando o planejamento.

---

## Implementações

- **Versão Funcional em Haskell**  
  Para explorar conceitos de programação funcional e imutabilidade na solução do problema.  

- **Versão Lógica em Prolog**  
  Para implementar e validar a lógica de restrições e alocações através de programação lógica.  

---


## Colaboradores

Este projeto foi desenvolvido por estudantes do curso de Ciência da Computação @ UFCG:


<table>
  <tr>
    <td align="center">
      <a href="https://github.com/eduardonsm">
        <img src="https://github.com/eduardonsm.png" width="120px;" alt="Eduardo Nogueira"/>
        <br />
        <sub><b>@Eduardo Nogueira</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/emmilyneri">
        <img src="https://github.com/emmilyneri.png" width="120px;" alt="Emmily Neri"/>
        <br />
        <sub><b>@Emmily Neri</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/jennifermedeiross">
        <img src="https://github.com/jennifermedeiross.png" width="120px;" alt="Jennifer Medeiros"/>
        <br />
        <sub><b>@Jennifer Medeiros</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/claraugusta">
        <img src="https://github.com/claraugusta.png" width="120px;" alt="Maria Clara Augusta"/>
        <br />
        <sub><b>@Maria Clara Augusta</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Luisprog1">
        <img src="https://github.com/Luisprog1.png" width="120px;" alt="Luís Alberto"/>
        <br />
        <sub><b>@Luís Alberto</b></sub>
      </a>
    </td>
  </tr>
</table>
