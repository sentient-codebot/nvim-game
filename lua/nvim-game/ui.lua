local M = {}

M.win_id = nil
M.buf_id = nil

function M.create_window()
  -- Create a new buffer
  M.buf_id = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Define window configuration
  local width = 40
  local height = 10
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = (editor_height - height) / 2,
    col = (editor_width - width) / 2,
    border = "rounded"
  }

  -- Create the floating window
  M.win_id = vim.api.nvim_open_win(M.buf_id, false, opts)
end

function M.render_card(card)
  if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then
    M.create_window()
  end

  local lines = {}
  table.insert(lines, "      NVIM GAME DOJO      ")
  table.insert(lines, string.rep("=", 26))
  table.insert(lines, "")
  
  if card.type == "operator" then
    table.insert(lines, "TASK: Operator")
    table.insert(lines, card.instruction)
    table.insert(lines, "")
    table.insert(lines, "Starting Text:")
    table.insert(lines, card.text)
  elseif card.type == "command" then
    table.insert(lines, "TASK: Command")
    table.insert(lines, card.instruction)
    table.insert(lines, "")
    table.insert(lines, "Press the keys!")
  end
  
  vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, lines)
end

function M.close()
  if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_win_close(M.win_id, true)
  end
  M.win_id = nil
  M.buf_id = nil
end

return M
