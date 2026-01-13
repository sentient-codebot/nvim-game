local analyzer = require('nvim-game.analyzer')
local generator = require('nvim-game.generator')
local ui = require('nvim-game.ui')

local M = {}

M.state = {
  active = false,
  current_card = nil,
  score = 0
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
  
  M.state.active = true
  M.state.score = 0
  
  M.next_round(bindings)
end

function M.next_round(bindings)
  if not M.state.active then return end
  
  -- Pick random binding
  local binding = bindings[math.random(#bindings)]
  local card = generator.generate(binding)
  M.state.current_card = card
  
  ui.render_card(card)
  
  -- Setup input verification
  if card.type == 'command' then
    M.wait_for_command(card)
  else
    M.setup_scratch_pad(card)
  end
end

function M.stop_session()
  M.state.active = false
  ui.close()
  -- Cleanup hooks/buffers here
end

function M.wait_for_command(card)
  -- Placeholder: In real plugin, use vim.on_key
  print("(Mock) Waiting for keys: " .. card.expected_keys)
end

function M.setup_scratch_pad(card)
  -- Placeholder: Create buffer with text
  -- vim.api.nvim_buf_set_lines(scratch_buf, ...)
  print("(Mock) Setup scratch pad for: " .. card.instruction)
end

return M
