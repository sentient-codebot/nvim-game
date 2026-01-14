package.path = package.path .. ';./lua/?.lua'

-- Mock dependencies
local mock_ui = {
  render_question = function(card) end,
  reveal_answer = function(card) end,
  map_key = function(lhs, cb) end,
  close = function() end
}

local mock_analyzer = {
  get_user_bindings = function() 
    return { { lhs = '<leader>f', desc = 'Find files' } } 
  end
}

local mock_generator = {
  generate = function(binding, deck)
    return { type = 'command', instruction = 'Mock instruction', expected_keys = binding.lhs, answer = binding.lhs }
  end
}

local mock_miner = {
  mine = function(path)
    return { "print('hello')" }
  end
}

-- Override require to return mocks
local old_require = require
require = function(mod)
  if mod == 'nvim-game.ui' then return mock_ui
  elseif mod == 'nvim-game.analyzer' then return mock_analyzer
  elseif mod == 'nvim-game.generator' then return mock_generator
  elseif mod == 'nvim-game.miner' then return mock_miner
  else return old_require(mod) end
end

local dojo = old_require('nvim-game.dojo')

-- Assert helper
local function assert(condition, msg)
  if not condition then error("Assertion failed: " .. (msg or "")) end
end

print("Testing nvim-game.dojo...")

-- Test Start Session
local rendered = false
mock_ui.render_question = function(card) 
  rendered = true
  assert(card.type == 'command', "Should generate command card")
end

dojo.start_session()
assert(dojo.state.active, "Game should be active")
assert(rendered, "UI should render card (render_question)")

-- Test Reveal Answer
local revealed = false
mock_ui.reveal_answer = function(card)
  revealed = true
end

dojo.reveal_answer()
assert(revealed, "UI should reveal answer")

-- Test Stop Session
local closed = false
mock_ui.close = function() closed = true end

dojo.stop_session()
assert(not dojo.state.active, "Game should be inactive")
assert(closed, "UI should be closed")

print("All Dojo tests passed!")
