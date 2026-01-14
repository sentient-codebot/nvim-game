
-- Set package.path to include current directory
package.path = package.path .. ";./lua/?.lua"

local miner = require("vimgame.miner")
local corpus_path = vim.fn.stdpath('data') .. "/nvim-game/corpus/requests"

print("Scanning corpus at: " .. corpus_path)
local files = miner.scan_dir(corpus_path)
print("Found " .. #files .. " python files.")

if #files == 0 then
    print("Error: No files found. Is the repo cloned?")
    os.exit(1)
end

print("Mining first file: " .. files[1])
local snippets = miner.extract_functions(files[1])
print("Found " .. #snippets .. " valid snippets in first file.")

print("Mining entire corpus...")
local deck = miner.mine(corpus_path)
print("Total snippets in deck: " .. #deck)

if #deck > 0 then
    print("\n--- Example Snippet ---")
    print(deck[1])
    print("-----------------------")
end
