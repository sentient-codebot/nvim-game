local M = {}

M.snippets = {
  "The quick brown fox jumps over the lazy dog.",
  "Lua is a powerful, efficient, lightweight, embeddable scripting language.",
  "Be water, my friend.",
  "function hello()\n  print('Hello World')\nend",
}

function M.get_random_text()
  return M.snippets[math.random(#M.snippets)]
end

-- Heuristic to determine if a binding is an operator/action or a command (tool/ui)
local function is_operator(binding)
  -- If it's a single key or standard operator-like, treat as operator
  -- This is heuristic and might need user config
  local lhs = binding.lhs
  if #lhs == 1 and lhs:match("%a") then return true end
  
  -- If description implies editing/modification
  local desc = binding.desc:lower()
  if desc:match("delete") or desc:match("change") or desc:match("yank") or desc:match("paste") then
    return true
  end
  
  return false
end

function M.generate_operator_exercise(binding, snippet)
  return {
    type = 'operator',
    instruction = "Apply '" .. binding.lhs .. "' (" .. binding.desc .. ") to the code.",
    text = snippet or M.get_random_text(),
    target = "TODO: Simulating outcome for " .. binding.lhs
  }
end

function M.generate_command_exercise(binding, snippet)
  return {
    type = 'command',
    instruction = "Perform the action: " .. binding.desc,
    expected_keys = binding.lhs,
    text = snippet or M.get_random_text()
  }
end

function M.generate(binding, deck)
  -- deck is a list of code snippets
  local snippet = nil
  if deck and #deck > 0 then
    snippet = deck[math.random(#deck)]
  end

  if is_operator(binding) then
    return M.generate_operator_exercise(binding, snippet)
  else
    return M.generate_command_exercise(binding, snippet)
  end
end

return M
