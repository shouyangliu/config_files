return {
    cmd = { 'clangd' },
    filetypes = {'cpp', 'cuda', 'c', 'h', 'hpp'},
    root_markers = {
        '.clangd',
        '.clagnd-tidy',
        '.clangd-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
    },
}
