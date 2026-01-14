local M = {}

M.win_id = nil
M.buf_id = nil

function M.create_window()
  -- Create a new buffer
  M.buf_id = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Define window configuration
  local width = 60
  local height = 20
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = (editor_height - height) / 2,
    col = (editor_width - width) / 2,
    border = "rounded",
    title = " Neovim Dojo ",
    title_pos = "center"
  }

  -- Create the floating window
  M.win_id = vim.api.nvim_open_win(M.buf_id, true, opts)
  
  -- Set some basic options for the window
  vim.api.nvim_win_set_option(M.win_id, 'wrap', true)
  vim.api.nvim_win_set_option(M.win_id, 'cursorline', false)
end

function M.render_question(card)
  if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then
    M.create_window()
  end
  
  -- Unlock buffer to write
  vim.api.nvim_buf_set_option(M.buf_id, 'modifiable', true)

  local lines = {}
  table.insert(lines, "")
  table.insert(lines, "  TASK: " .. (card.type == 'operator' and "Edit" or "Command"))
  table.insert(lines, string.rep("-", 50))
  table.insert(lines, "  " .. card.instruction)
  table.insert(lines, "")
  table.insert(lines, string.rep("-", 50))
  table.insert(lines, "  CONTEXT:")
  table.insert(lines, "")
  
  -- Split snippet into lines and indent
  if card.text then
      for s in card.text:gmatch("[^\r\n]+") do
          table.insert(lines, "    " .. s)
      end
  end
  
  table.insert(lines, "")
  table.insert(lines, string.rep("=", 50))
  table.insert(lines, "  [Enter] Reveal Answer   [q] Quit")
  
  vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, lines)
  
  -- Lock buffer
  vim.api.nvim_buf_set_option(M.buf_id, 'modifiable', false)
end

function M.reveal_answer(card)
  if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then return end
  
  vim.api.nvim_buf_set_option(M.buf_id, 'modifiable', true)
  
  local lines = vim.api.nvim_buf_get_lines(M.buf_id, 0, -1, false)
  -- Remove the footer (last 2 lines likely) or just append
  
  table.insert(lines, "") 
  table.insert(lines, "  ANSWER: " .. card.answer)
  table.insert(lines, "")
  table.insert(lines, "  [Space] Next Card       [q] Quit")
  
  vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(M.buf_id, 'modifiable', false)
end

function M.map_key(lhs, callback)
    if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then return end
    vim.keymap.set('n', lhs, callback, { buffer = M.buf_id, noremap = true, silent = true, nowait = true })
end

function M.close()
  if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_win_close(M.win_id, true)
  end
  if M.buf_id and vim.api.nvim_buf_is_valid(M.buf_id) then
      vim.api.nvim_buf_delete(M.buf_id, { force = true })
  end
  M.win_id = nil
  M.buf_id = nil
end

return M
