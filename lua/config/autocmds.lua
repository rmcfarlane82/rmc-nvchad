local function find_nearest_csproj(start_dir)
  local matches = vim.fs.find(function(name)
    return name:match("%.csproj$")
  end, { path = start_dir, upward = true })
  return matches[1]
end

local function calculate_namespace(file_path)
  local dir = vim.fs.dirname(file_path)
  local csproj = find_nearest_csproj(dir)
  if not csproj then
    return nil
  end

  local csproj_dir = vim.fs.dirname(csproj)
  local project_name = vim.fn.fnamemodify(csproj, ":t:r")
  local dir_abs = vim.fn.fnamemodify(dir, ":p"):gsub("[/\\]+$", "")
  local csproj_dir_abs = vim.fn.fnamemodify(csproj_dir, ":p"):gsub("[/\\]+$", "")
  local relative = nil
  if dir_abs:sub(1, #csproj_dir_abs) == csproj_dir_abs then
    relative = dir_abs:sub(#csproj_dir_abs + 1):gsub("^[/\\]", "")
  end
  if not relative or relative == "" or relative == "." then
    return project_name
  end

  local suffix = relative:gsub("[/\\]", "."):gsub("%.+$", "")
  return project_name .. "." .. suffix
end

local function insert_csharp_template(bufnr)
  if vim.b[bufnr].csharp_template_applied then
    return
  end

  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == "" then
    return
  end

  local type_name = vim.fn.fnamemodify(file_path, ":t:r")
  local namespace = calculate_namespace(file_path)

  local choices = { "empty", "class", "interface", "enum", "struct", "record" }
  vim.ui.select(choices, { prompt = "C# item to create" }, function(choice)
    if not choice then
      return
    end
    if choice == "empty" then
      vim.b[bufnr].csharp_template_applied = true
      return
    end

    local lines = {}
    if namespace and namespace ~= "" then
      table.insert(lines, "namespace " .. namespace .. ";")
      table.insert(lines, "")
    end

    local declaration = string.format("public %s %s", choice, type_name)
    if choice == "record" then
      declaration = declaration .. ";"
      table.insert(lines, declaration)
    else
      table.insert(lines, declaration)
      table.insert(lines, "{")
      table.insert(lines, "}")
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { #lines, 1 })
    vim.b[bufnr].csharp_template_applied = true
  end)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("CSharpNewFileTemplate", { clear = true }),
  pattern = "*.cs",
  callback = function(args)
    if vim.api.nvim_buf_line_count(args.buf) > 1 then
      return
    end
    if vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] ~= "" then
      return
    end
    local file_path = vim.api.nvim_buf_get_name(args.buf)
    if file_path == "" then
      return
    end
    local stat = vim.uv.fs_stat(file_path)
    if stat and stat.size > 0 then
      return
    end
    insert_csharp_template(args.buf)
  end,
  desc = "Insert C# namespace/type template for new files",
})
