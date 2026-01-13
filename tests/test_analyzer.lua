-- Mock vim global
_G.vim = {
  api = {
    nvim_get_keymap = function(mode)
      if mode == 'n' then
        return {
          { lhs = '<leader>f', rhs = ':Telescope find_files<CR>', desc = 'Find files' },
          { lhs = '<leader>g', rhs = ':LazyGit<CR>', desc = '' }, -- Empty desc, should skip
          { lhs = 'j', rhs = 'gj' }, -- No desc, should skip
          { lhs = '<leader>c', rhs = '', desc = 'Code action' },
        }
      elseif mode == 'i' then
        return {
           { lhs = 'jj', rhs = '<Esc>', desc = 'Exit insert mode' },
           { lhs = '<C-s>', rhs = '', desc = 'Surround add' } -- Simulating surround plugin
        }
      end
      return {}
    end
  }
}

-- Setup package.path to find the module
package.path = package.path .. ';./lua/?.lua'

local analyzer = require('nvim-game.analyzer')
local results = analyzer.get_user_bindings()

-- Simple assertion helper
local function assert_eq(a, b, msg)
  if a ~= b then error("Assertion failed: " .. msg .. " (Expected " .. tostring(b) .. ", got " .. tostring(a) .. ")") end
end

print("Testing nvim-game.analyzer...")

assert_eq(#results, 4, "Should return 4 mappings (2 normal + 2 insert)")

-- Verify Normal Mode + Plugin Detection
local find_files = results[1]
assert_eq(find_files.lhs, '<leader>f', "Mapping lhs")
assert_eq(find_files.plugin, 'Telescope', "Plugin detection for Telescope")
assert_eq(find_files.mode, 'n', "Mode detection")

-- Verify Normal Mode + User
local code_action = results[2]
assert_eq(code_action.desc, 'Code action', "Mapping desc")
assert_eq(code_action.plugin, 'User', "Default plugin detection")

-- Verify Insert Mode
local exit_insert = results[3]
assert_eq(exit_insert.lhs, 'jj', "Insert mapping lhs")
assert_eq(exit_insert.mode, 'i', "Insert mode detection")

-- Verify Insert Mode + Plugin (Surround)
local surround = results[4]
assert_eq(surround.plugin, 'Surround', "Surround plugin detection")

print("All tests passed!")
