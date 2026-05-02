-- Docker 容器 LSP 管理
local M = {}

-- 检测容器内是否有某个命令
local function container_has_command(container, cmd)
    local check_cmd = string.format("docker exec %s which %s 2>/dev/null", container, cmd)
    local handle = io.popen(check_cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
    end
    return false
end

-- 在容器内安装 LSP
function M.install_lsp_in_container(container)
    if not container or container == "" then
        vim.notify("请指定容器名称: :LspInstallInContainer <container_name>", vim.log.levels.WARN)
        return
    end

    vim.notify("开始在容器 " .. container .. " 中安装 LSP...", vim.log.levels.INFO)

    -- 安装常用 LSP 的命令
    local install_cmds = {
        lua_ls = "apt-get update && apt-get install -y lua-language-server",
        clangd = "apt-get update && apt-get install -y clangd",
        pyright = "pip install pyright",
        cmake = "pip install cmake-language-server",
    }

    for name, cmd in pairs(install_cmds) do
        if not container_has_command(container, name == "pyright" and "pyright-langserver" or name) then
            vim.notify("安装 " .. name .. "...", vim.log.levels.INFO)
            local full_cmd = string.format("docker exec %s bash -c '%s'", container, cmd)
            vim.fn.system(full_cmd)
            if vim.v.shell_error == 0 then
                vim.notify(name .. " 安装成功", vim.log.levels.INFO)
            else
                vim.notify(name .. " 安装失败", vim.log.levels.ERROR)
            end
        else
            vim.notify(name .. " 已存在，跳过", vim.log.levels.INFO)
        end
    end
end

-- 启动容器内的 LSP
function M.start_container_lsp(container)
    if not container or container == "" then
        vim.notify("请指定容器名称: :LspStartContainer <container_name>", vim.log.levels.WARN)
        return
    end

    -- 检测并提示缺少的 LSP
    local lsp_checks = {
        { name = "lua_ls", cmd = "lua-language-server" },
        { name = "clangd", cmd = "clangd" },
        { name = "pyright", cmd = "pyright-langserver" },
        { name = "cmake", cmd = "cmake-language-server" },
    }

    local missing = {}
    for _, check in ipairs(lsp_checks) do
        if not container_has_command(container, check.cmd) then
            table.insert(missing, check.name)
        end
    end

    if #missing > 0 then
        vim.notify("容器内缺少 LSP: " .. table.concat(missing, ", ") .. "。使用 :LspInstallInContainer " .. container .. " 安装", vim.log.levels.WARN)
        return
    end

    -- 停止当前 LSP
    vim.lsp.stop_client(vim.lsp.get_clients())

    -- 配置并启动容器内的 LSP
    vim.lsp.config('lua_ls', {
        cmd = { "docker", "exec", container, "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                telemetry = { enable = false },
            },
        },
    })

    vim.lsp.config('clangd', {
        cmd = { "docker", "exec", container, "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
    })

    vim.lsp.config('pyright', {
        cmd = { "docker", "exec", container, "pyright-langserver", "--stdio" },
        filetypes = { "python" },
    })

    vim.lsp.enable({ "lua_ls", "clangd", "pyright" })

    vim.notify("已切换到容器 " .. container .. " 的 LSP", vim.log.levels.INFO)
end

-- 恢复本地 LSP
function M.stop_container_lsp()
    vim.lsp.stop_client(vim.lsp.get_clients())
    require("lsp.init")
    vim.notify("已恢复本地 LSP", vim.log.levels.INFO)
end

return M
