return {
    -- 指定 CMake LSP 可执行文件（默认 PATH 中找，若路径非默认需写绝对路径）
    cmd = { 'cmake-language-server' },
    -- 接管的文件类型（CMakeLists.txt + .cmake 文件）
    filetypes = { 'cmake', 'CMakeLists.txt' },
    -- 工程根目录检测（按优先级查找标识文件）
    root_dir = function(fname)
        local root_files = {
            'CMakeLists.txt',       -- 核心标识：根目录的 CMakeLists.txt
            'cmakePresets.json',    -- CMake 预设文件
            'CTestConfig.cmake',    -- CTest 配置
            '.git',                 -- 回退：git 仓库根目录
        }
        return vim.fs.dirname(vim.fs.find(root_files, {
            path = fname,
            upward = true,
            stop = vim.loop.os_homedir(),
        })[1]) or vim.fn.getcwd()
    end,
    -- CMake LSP 专属配置（按需调整）
    settings = {
        cmake = {
            -- 默认构建目录（和你的工程习惯匹配）
            buildDirectory = 'build',
            -- CMake 可执行文件路径（默认找系统 cmake）
            cmakePath = 'cmake',
            -- 启用补全/诊断增强
            completion = {
                enable = true,
                placeholder = true, -- 补全时显示参数占位符
            },
            diagnostics = {
                enable = true,      -- 启用语法/逻辑诊断
                severity = 'warning' -- 诊断级别：error/warning/info
            },
            -- 启用内嵌提示（ghost text，Neovim 0.10+ 支持）
            inlayHints = {
                enable = true,
                parameterNames = true, -- 显示函数参数名
                parameterTypes = true  -- 显示参数类型
            }
        }
    },
    -- 超时时间（单位：毫秒）
    timeout_ms = 5000,
}
