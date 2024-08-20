local defintionFilePath = vim.fn.stdpath "data" .. "\\LuauDefinitionFiles"

local function Clear(dir)
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return false end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local fullPath = dir .. "/" .. name

    if type == "file" then
      vim.uv.fs_unlink(fullPath)
    elseif type == "directory" then
      Clear(fullPath)
      vim.uv.fs_rmdir(fullPath)
    end
  end

  return true
end

local function GetglobalTypes()
  local uri = "https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.luau"
  local request = "curl -o " .. defintionFilePath .. "\\globalTypes.d.luau " .. uri
  os.execute(request)
end

local function GetApiDocs()
  local uri = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/api-docs/en-us.json"
  local request = "curl -o " .. defintionFilePath .. "\\docs_en-us.json " .. uri
  os.execute(request)
end

if vim.fn.isdirectory(defintionFilePath) == 0 then
  vim.fn.mkdir(defintionFilePath)
  GetglobalTypes()
  GetApiDocs()
else
  if not vim.uv.fs_stat(defintionFilePath .. "\\globalTypes.d.luau") then
    print "luau not found 🥺"
    --GetglobalTypes()
  end

  if not vim.uv.fs_stat(defintionFilePath .. "\\docs_en-us.json") then
    GetApiDocs()
  end
end

local function update(msg)
  vim.api.nvim_command "redraw"
  vim.api.nvim_out_write(msg .. "\n")
end

vim.api.nvim_create_user_command("FetchRobloxDefinitions", function()
  update "\x1b[31mDeleting old files...\x1b[0m"
  if not Clear(defintionFilePath) then vim.fn.mkdir(defintionFilePath) end

  update "\x1b[32mFetching types...\x1b[0m"
  GetglobalTypes()

  update "\x1b[32mFetching API docs...\x1b[0m"
  GetApiDocs()
end, { nargs = 0 })
