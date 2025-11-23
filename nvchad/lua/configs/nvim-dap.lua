
local dap = require("dap")

-- ---- adapter (fix the path if needed) ----
local function get_dotnet_path()
    if vim.loop.os_uname().version:match("Windows") then
        return [[\mason\packages\netcoredbg\netcoredbg\netcoredbg.exe]]
    end
   return [[/mason/packages/netcoredbg/netcoredbg]]
end

local mason_path = vim.fn.stdpath("data") .. get_dotnet_path()

dap.adapters.netcoredbg = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}
dap.adapters.coreclr = dap.adapters.netcoredbg

-- ---- helpers: build + pick newest dll ----
local function build_debug()
  -- blocks until build finishes (simple & reliable)
  local cmd = { "dotnet", "build", "-c", "Debug" }
  vim.notify("Building (Debug)…", vim.log.levels.INFO, { title = "nvim-dap" })
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Build failed:\n" .. out, vim.log.levels.ERROR, { title = "nvim-dap" })
    return false
  end
  return true
end

local function newest_dll(root)
  -- find all candidate dlls under bin/Debug/* (skip ref/nuget/artifacts/etc.)
  local iter = vim.fs.find(function(name, path)
    if name:sub(-4):lower() ~= ".dll" then return false end
    if path:find("/bin/Debug/") == nil then return false end
    if path:find("/ref/") or path:find("/runtimes/") then return false end
    local lname = name:lower()
    if lname == "apphost.exe" or lname == "vhost.exe" then return false end
    if lname == "testhost.dll" then return false end
    return true
  end, { type = "file", limit = math.huge, path = root })

  local newest, newest_mtime = nil, 0
  for _, p in ipairs(iter) do
    local st = vim.uv.fs_stat(p)
    if st and st.mtime and st.mtime.sec >= newest_mtime then
      newest, newest_mtime = p, st.mtime.sec
    end
  end
  return newest
end

local function build_then_pick_dll()
  local cwd = vim.fn.getcwd()
  if not build_debug() then
    return nil
  end
  local dll = newest_dll(cwd)
  if not dll then
    -- fallback to prompt if detection failed
    dll = vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
  end
  return dll
end

-- ---- DAP configurations for C# ----
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch (build → newest dll)",
    request = "launch",
    program = function()
      local dll = build_then_pick_dll()
      assert(dll and #dll > 0, "No DLL selected/found")
      return dll
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    justMyCode = true,
  },
  {
    type = "coreclr",
    name = "Attach (pick process)",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}


require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })


