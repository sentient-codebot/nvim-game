package.path = package.path .. ';./lua/?.lua'

-- Mock vim global
local lines_set = false
local win_opened = false
local win_closed = false

_G.vim = {
  api = {
    nvim_create_buf = function() return 1 end,
    nvim_open_win = function() win_opened = true; return 10 end,
    nvim_buf_is_valid = function(buf) return buf == 1 end,
    nvim_win_is_valid = function(win) return win == 10 end,
    nvim_buf_set_lines = function() lines_set = true end,
    nvim_win_close = function() win_closed = true end
  },
  o = {
    columns = 80,
    lines = 24
  }
}

local ui = require('nvim-game.ui')

-- Simple assertion helper
local function assert(condition, msg)
  if not condition then error("Assertion failed: " .. (msg or "")) end
end

print("Testing nvim-game.ui...")

-- Test Render Card (should open window if not exists)
local card = { type = 'command', instruction = 'Press <SPC>f', text = nil }
ui.render_card(card)

assert(win_opened, "Window should be opened")
assert(lines_set, "Buffer lines should be set")

-- Test Close
ui.close()
assert(win_closed, "Window should be closed")

print("All UI tests passed!")
