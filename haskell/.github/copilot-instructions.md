# Copilot Instructions for alocador-turmasCSP (Haskell)

## Project Overview
This project is a Haskell-based class and resource allocator, organized by domain-driven modules. It manages classes, classrooms, users, and their requirements, supporting interactive CLI workflows for professors and administrators.

## Architecture & Key Components
- **src/Main.hs**: Entry point, orchestrates app startup and main loop.
- **src/Tipos.hs**: Core data types (`Class`, `Resource`, etc.) used throughout the system.
- **src/Repository/**: Data access layer for classes, classrooms, and users. Use these modules for CRUD operations and parsing logic.
- **src/View/**: UI logic for different user roles (Admin, Professor, etc.). Each view module handles CLI interactions and menu flows.
- **src/Utils/**: Utility functions for resource management, allocation, and scheduling.
- **src/data/**: Text files for persistent storage (class.txt, classroom.txt, user.txt). Data is loaded and saved via repository modules.

## Developer Workflows
- **Build**: Use `stack build` (or VS Code task "haskell build") to compile the project.
- **Test**: Run `stack test` (or VS Code task "haskell test") for automated tests.
- **Clean & Build**: Use `stack clean && stack build` for a fresh build.
- **Watch**: Use `stack build --test --no-run-tests --file-watch` for live rebuilds.

## Project-Specific Patterns
- **CLI Menus**: Each user role has a dedicated menu function (e.g., `professorMenu` in `ProfessorView.hs`). Menus loop until a valid option is selected.
- **Data Updates**: To update entities (e.g., class requirements), filter and map over lists, replacing the target item by ID.
- **Parsing**: Use `parseResource` (from `ClassRepository.hs`) to convert string requirements to typed resources.
- **Error Handling**: Use `readMaybe` for safe input parsing and prompt users to retry on invalid input.
- **Separation of Concerns**: UI logic is kept in `View/`, data logic in `Repository/`, and business logic in `Utils/`.

## Integration Points
- **Persistent Storage**: All data is read from and written to text files in `src/data/` via repository modules.
- **External Libraries**: Uses `splitOn` from `Data.List.Split` for string parsing, and standard Haskell libraries for IO and parsing.

## Example Patterns
- To update class requirements:
  ```haskell
  let clss' = map (\c -> if classId c == turmaIdInt then c { requirements = novosRequisitos } else c) clss
  ```
- To parse user input safely:
  ```haskell
  case readMaybe turmaId :: Maybe Int of
    Nothing -> ... -- prompt again
    Just turmaIdInt -> ...
  ```

## Key Files & Directories
- `src/View/ProfessorView.hs`: Professor CLI logic and requirement updates
- `src/Repository/ClassRepository.hs`: Class data access and parsing
- `src/Tipos.hs`: Data type definitions
- `src/data/`: Persistent storage

## Conventions
- Use explicit type signatures for top-level functions
- Keep UI, data, and business logic separated by directory
- Always validate user input before processing

---
For questions or unclear patterns, review the relevant module or ask for clarification. Update this file as new conventions or workflows emerge.
