local M = {}

---Scan a directory recursively for .py files
---@param path string
---@return string[]
function M.scan_dir(path)
    -- Ensure path has no trailing slash for consistency, though glob handles it
    local pattern = path .. "/**/*.py"
    -- glob returns a list (table) when 3rd arg is true
    local files = vim.fn.glob(pattern, true, true)
    return files
end

---Extract function definitions from a file using Tree-sitter
---@param file_path string
---@return string[] snippets
function M.extract_functions(file_path)
    local file = io.open(file_path, "r")
    if not file then return {} end
    local content = file:read("*a")
    file:close()
    if not content or content == "" then return {} end

    -- Check if python parser is available
    local ok, parser = pcall(vim.treesitter.get_string_parser, content, "python")
    if not ok or not parser then
        -- silently fail or warn? For now return empty
        return {} 
    end

    local tree = parser:parse()[1]
    if not tree then return {} end
    local root = tree:root()

    local query_text = [[
        (function_definition) @function
    ]]
    
    local ok_query, query = pcall(vim.treesitter.query.parse, "python", query_text)
    if not ok_query then return {} end

    local snippets = {}

    for _, node in query:iter_captures(root, content, 0, -1) do
        local start_row, _, end_row, _ = node:range()
        local line_count = end_row - start_row + 1
        
        if line_count >= 5 and line_count <= 20 then
             local text = vim.treesitter.get_node_text(node, content)
             table.insert(snippets, text)
        end
    end

    return snippets
end

---Main function to mine the corpus
---@param corpus_path string
---@return string[] deck
function M.mine(corpus_path)
    local files = M.scan_dir(corpus_path)
    local deck = {}
    
    for _, file in ipairs(files) do
        local funcs = M.extract_functions(file)
        for _, code in ipairs(funcs) do
            table.insert(deck, code)
        end
    end
    
    return deck
end

return M
