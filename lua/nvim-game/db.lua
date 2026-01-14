local M = {}

-- Ensure the data directory exists
local data_path = vim.fn.stdpath("data") .. "/nvim-game"
if vim.fn.isdirectory(data_path) == 0 then
  vim.fn.mkdir(data_path, "p")
end

local db_file = data_path .. "/db.json"

---Load exercises from the JSON database
---@return table|nil List of exercises or nil if empty/error
function M.load_exercises()
  local file = io.open(db_file, "r")
  if not file then
    return {}
  end

  local content = file:read("*a")
  file:close()

  if not content or content == "" then
    return {}
  end

  local ok, param = pcall(vim.json.decode, content)
  if ok then
    return param
  else
    return {}
  end
end

---Save exercises to the JSON database
---@param exercises table List of exercises
function M.save_exercises(exercises)
  local file = io.open(db_file, "w")
  if not file then
    print("Error: Could not open database file for writing: " .. db_file)
    return
  end

  local ok, encoded = pcall(vim.json.encode, exercises)
  if ok then
    file:write(encoded)
  else
    print("Error: Could not encode exercises to JSON")
  end
  file:close()
end

---Add a single exercise to the database
---@param exercise table The exercise object to add
function M.add_exercise(exercise)
  local exercises = M.load_exercises()
  table.insert(exercises, exercise)
  M.save_exercises(exercises)
end

---Clear the database
function M.clear()
  M.save_exercises({})
end

return M
