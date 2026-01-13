package.path = package.path .. ';./lua/?.lua'

local generator = require('nvim-game.generator')

-- Simple assertion helper
local function assert(condition, msg)
  if not condition then error("Assertion failed: " .. (msg or "")) end
end

print("Testing nvim-game.generator...")

-- Test Command (e.g. Telescope)
local cmd_binding = { lhs = '<leader>f', desc = 'Find files' }
local cmd_ex = generator.generate(cmd_binding)
assert(cmd_ex.type == 'command', "Should generate command type")
assert(cmd_ex.expected_keys == '<leader>f', "Expected keys should match")
print("Command test passed")

-- Test Operator (e.g. Delete)
local op_binding = { lhs = 'd', desc = 'Delete' }
local op_ex = generator.generate(op_binding)
assert(op_ex.type == 'operator', "Should generate operator type")
assert(op_ex.text ~= nil, "Should have text")
assert(op_ex.target ~= nil, "Should have target")
print("Operator test passed")

print("All generator tests passed!")
