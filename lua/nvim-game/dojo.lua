local analyzer = require('nvim-game.analyzer')
local generator = require('nvim-game.generator')
local miner = require('nvim-game.miner')
local ui = require('nvim-game.ui')

local M = {}

M.state = {
  active = false,
  current_card = nil,
  score = 0,
  deck = {},
  bindings = {}
}

function M.start_session()
  if M.state.active then 
    print("Game already running!")
    return
  end

  local bindings = analyzer.get_user_bindings()
  if #bindings == 0 then
    print("No meaningful bindings found! Add some 'desc' fields to your keymaps.")
    return
  end
  M.state.bindings = bindings
  
  M.state.active = true
  M.state.score = 0
  
  -- Load snippets
  local corpus = vim.fn.stdpath('data') .. '/nvim-game/corpus'
  M.state.deck = miner.mine(corpus)
  if #M.state.deck == 0 then
      print("Warning: No python snippets found in " .. corpus .. ". Using default sentences.")
  end

  M.next_round()
end

function M.next_round()
  if not M.state.active then return end
  
  -- Pick random binding
  local binding = M.state.bindings[math.random(#M.state.bindings)]
  local card = generator.generate(binding, M.state.deck)
  M.state.current_card = card
  
  -- Render Question
  ui.render_question(card)
  
  -- Bind Keys for Question State
  ui.map_key('<CR>', M.reveal_answer)
  ui.map_key('q', M.stop_session)
end

function M.reveal_answer()
  if not M.state.active or not M.state.current_card then return end
  
  ui.reveal_answer(M.state.current_card)
  
  -- Bind Keys for Answer State
  ui.map_key('<Space>', M.next_round)
  ui.map_key('q', M.stop_session)
end

function M.stop_session()
  M.state.active = false
  ui.close()
  -- Clear state
  M.state.current_card = nil
  M.state.deck = {}
  M.state.bindings = {}
end

return M
