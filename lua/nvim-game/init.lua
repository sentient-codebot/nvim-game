local dojo = require('nvim-game.dojo')

local M = {}

M.setup = function(opts)
  -- Create user commands
  vim.api.nvim_create_user_command('NvimGame', function()
    dojo.start_session()
  end, {})
  
  vim.api.nvim_create_user_command('NvimGameStop', function()
    dojo.stop_session()
  end, {})
end

return M
