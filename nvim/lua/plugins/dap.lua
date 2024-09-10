return
{
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = 'executable',
            command = "~/.local/share/nvim/mason/bin/OpenDebugAD7",
        }
        dap.configurations.cpp = {
          {
            name = 'Launch',
            type = 'cppdbg',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
            args = {},
        
            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            -- runInTerminal = false,
          },
        }
          dap.configurations.c = dap.configurations.cpp
    end
    --config = function()
    --    require('nvim-dap').setup()
    --end
}
