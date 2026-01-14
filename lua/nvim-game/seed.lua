-- lua/nvim-game/seed.lua
-- Run with: nvim -l lua/nvim-game/seed.lua

-- Add the current directory to the package path so we can require modules
package.path = package.path .. ";./lua/?.lua"

local function setup_rtp()
  local parser_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
  if vim.fn.isdirectory(parser_path) == 1 then
    vim.opt.rtp:prepend(parser_path)
  end
end
setup_rtp()

local analyzer = require("nvim-game.analyzer")
local miner = require("nvim-game.miner")
local generator = require("nvim-game.generator")
local db = require("nvim-game.db")

local function ensure_corpus()
  local data_path = vim.fn.stdpath("data") .. "/nvim-game/corpus"
  if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path, "p")
  end

  local requests_path = data_path .. "/requests"
  if vim.fn.isdirectory(requests_path) == 0 then
    print("Cloning 'requests' repository for corpus...")
    vim.fn.system({ "git", "clone", "https://github.com/psf/requests", requests_path })
  end
  return requests_path
end

local function main()
  print("Starting seed process...")

  -- 1. Setup Corpus
  local corpus_path = ensure_corpus()
  print("Corpus path: " .. corpus_path)

  -- 2. Mine Snippets
  print("Mining snippets...")
  local deck = miner.mine(corpus_path)
  print("Mined " .. #deck .. " snippets.")

  if #deck == 0 then
    print("Error: No snippets mined. Check corpus path or limits.")
    return
  end

  -- 3. Get Bindings
  print("Fetching user bindings...")
  local bindings = analyzer.get_user_bindings()
  print("Found " .. #bindings .. " bindings.")

  if #bindings == 0 then
    print("Warning: No bindings found with descriptions. Adding dummy binding.")
    table.insert(bindings, { lhs = "<leader>w", desc = "Save file", mode = "n" })
  end

  -- 4. Generate Exercises
  print("Generating 200 exercises...")
  local exercises = {}
  local target_count = 200

  for i = 1, target_count do
    -- Pick a random binding
    local binding = bindings[math.random(#bindings)]
    
    -- Generate exercise
    local ex = generator.generate(binding, deck)
    table.insert(exercises, ex)
    
    if i % 50 == 0 then
      io.write(".")
      io.flush()
    end
  end
  print("\nGenerated " .. #exercises .. " exercises.")

  -- 5. Save to DB
  print("Saving to database...")
  db.save_exercises(exercises)
  print("Done!")
end

main()
