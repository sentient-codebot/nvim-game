# Project Roadmap: Neovim Keybinding Game

## Goal
Build a mini-game running inside Neovim to practice custom keybindings and plugin usage. The game acts like flashcards, presenting code snippets (starting with Python) that require specific edits using your actual keybindings.

## Architecture

1.  **Analyzer (`lua/nvim-game/analyzer.lua`)**
    *   **Purpose**: Inspects the user's running Neovim instance.
    *   **Function**: `get_user_bindings()` scans global and mode-specific keymaps.
    *   **Logic**: Filters for mappings with `desc` (descriptions) and identifies plugins (e.g., Telescope, Gitsigns).
    *   **Status**: [x] Basic implementation completed.

2.  **Snippet Extractor (Tree-sitter)**
    *   **Purpose**: Surgically extracts "bite-sized" atomic code units (functions, classes) from source files.
    *   **Logic**: Uses Neovim's built-in Tree-sitter to parse Python files and query for specific nodes (e.g., `function_definition`, `class_definition`).
    *   **Status**: [x] Implemented (Basic mining).

3.  **Exercise Generator**
    *   **Purpose**: Dynamically creates exercises based on the analyzed bindings and extracted snippets.
    *   **Logic**:
        *   Maps a keybinding (e.g., `<leader>ff`) to a specific code context.
        *   Uses **Snippet Extractor** to get real code.
    *   **Output**: A set of "Flashcards" containing:
        *   `Question`: The task (e.g., "Use Telescope to find a file").
        *   `Snippet`: Code context (real Python function/class).
        *   `Expected Action`: The keybinding to press.
    *   **Status**: [x] Implemented.

4.  **Exercise Database**
    *   **Purpose**: scalable storage for the "Exercise Base".
    *   **Format**: Likely JSON or Lua tables.
    *   **Content**: "Real practical exercises in Python code snippets."
    *   **Status**: [x] Implemented (Basic JSON persistence).

5.  **Game Engine**
    *   **Purpose**: Manages the game loop.
    *   **Flow**:
        1.  **Launch**: Command to start.
        2.  **Draw**: Randomly select an exercise.
        3.  **Prompt**: Show the code snippet and task.
        4.  **Action**: User performs the edit/action.
        5.  **Verify**: Check if correct keys were used or buffer state matches.
        6.  **Answer**: Show the expected keybinding.
    *   **Status**: [ ] Planned.

6.  **UI Layer**
    *   **Purpose**: Display the game interface.
    *   **Components**: Floating windows for flashcards, dashboard.
    *   **Status**: [ ] Planned.

## Roadmap & Progress

- [x] **Phase 1: Analysis**
    - [x] Create `analyzer.lua` to fetch user keybindings.
    - [x] Filter for meaningful mappings (those with `desc`).
    - [x] Basic plugin detection.

- [x] **Phase 2: Exercise Foundation**
    - [x] **Tree-sitter Integration**: Implement logic to extract functions/classes from Python files.
    - [x] Design the data structure for an "Exercise".
    - [x] Create/Curate a library of source Python files to harvest snippets from (Using `requests` repo).
    - [x] Implement the `Exercise Generator` linking bindings to Tree-sitter snippets.

- [ ] **Phase 3: Game Core**
    - [ ] Implement the prompt/flashcard UI.
    - [ ] Create the logic to "draw" a random card.
    - [ ] Build the mechanism to show the "Answer".

- [ ] **Phase 4: Interaction & Instructions**
    - [ ] Add commands to Launch/Close the game.
    - [ ] Create a clear Instructions screen.
    - [ ] Refine the verification loop.
