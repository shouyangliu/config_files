return {
    cmd = { 'clangd' },
    filetypes = {'cpp', 'cuda', 'c', 'h', 'hpp'},
    root_markers = {
        '.clangd',
        '.clangd-tidy',
        '.clangd-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
    },
    settings = {
        clangd = {
            inlayHints = {
                enabled = true,
                parameterNames = true,
                parameterTypes = true,
                variableTypes = true,
                functionalReturnTypes = true
            }
        }
    }
}
