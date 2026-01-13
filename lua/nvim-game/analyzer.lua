local M = {}

---Scan keymaps for a specific mode
---@param mode string 'n' or 'i'
---@return table[] List of mappings
local function scan_mode(mode)
  local maps = vim.api.nvim_get_keymap(mode)
  local valid_maps = {}

  for _, map in ipairs(maps) do
    if map.desc and map.desc ~= "" then
      -- Heuristic for plugin detection
      local plugin = "User"
      local desc_lower = map.desc:lower()
      local rhs_lower = (map.rhs or ""):lower()
      
      if desc_lower:match("telescope") or rhs_lower:match("telescope") then
        plugin = "Telescope"
      elseif desc_lower:match("gitsigns") or rhs_lower:match("gitsigns") then
        plugin = "Gitsigns"
      elseif desc_lower:match("surround") or rhs_lower:match("surround") then
        plugin = "Surround"
      end

      table.insert(valid_maps, {
        lhs = map.lhs,
        rhs = map.rhs or "",
        desc = map.desc,
        mode = mode,
        plugin = plugin
      })
    end
  end
  return valid_maps
end

---Get all user bindings for Normal and Insert mode
---@return table[] Combined list of mappings
function M.get_user_bindings()
  local normal_maps = scan_mode('n')
  local insert_maps = scan_mode('i')
  
  -- Combine lists
  local all_maps = {}
  for _, m in ipairs(normal_maps) do table.insert(all_maps, m) end
  for _, m in ipairs(insert_maps) do table.insert(all_maps, m) end
  
  return all_maps
end

return M
