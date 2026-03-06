# 配置更新日志

## 2024-03-07

### 1. 安装脚本优化

- **install.sh**: 修复相对路径问题，使用绝对路径确保脚本正确执行
- **nvim/install.sh**: 
  - 新增 `--with-plugins` 参数，可选择安装时克隆所有插件
  - 默认仅安装 lazy.nvim，首次启动 nvim 时自动安装插件
  - 使用软链接代替复制配置文件
- **fcitx/install.sh**: 移除 root 权限依赖，改为配置到用户目录
- **nerdfont/install.sh**: 统一复制到 `/usr/share/fonts`
- **polybar/install.sh**: 修复 setup.sh 路径问题，使用已有的 polybar-themes-master
- **kitty/install.sh**: 新增，使用 apt 安装
- **wezterm/install.sh**: 添加 AppImage 备选方案

### 2. Neovim 插件整理

**删除的插件:**
- `neon.lua` - 与 color.lua 重复
- `noice.lua` - 功能冗余
- `nvim-notify.lua` - 已禁用
- `dropbar.lua` - 与 bufferline 冲突
- `startup.lua` - 功能重复
- `leetcode.lua` - 不常用
- `git-blame.lua` - 不常用
- `flash.lua` - 不常用
- `mini.lua` (satellite.nvim) - 不常用

**保留的插件:**
- `nvim-tree.lua` - 文件树
- `telescope.lua` - 文件搜索
- `treesitter.lua` - 语法高亮
- `cmp.lua` - 代码补全
- `mason.lua` - LSP 管理
- `lualine.lua` - 状态栏
- `bufferline.lua` - 标签栏
- `gitsigns.lua` - Git 集成
- `fold.lua` - 代码折叠
- `color.lua` - 主题
- `dap.lua` / `dap_ui.lua` - 调试

**配置简化:**
- `init.lua`: 精简配置，移除冗余的 neovide 设置
- `keymaps.lua`: 精简快捷键，保留核心功能
- 各插件配置: 简化配置项，保留核心功能

### 3. 终端配置

**Wezterm:**
- 新增 `leader` 快捷键 `Ctrl+s`
- 快捷键与 tmux 风格一致

**Kitty:**
- 新增终端配置
- 快捷键与 Wezterm 保持一致

### 4. DWM

- 默认终端改为 wezterm

---

## 使用方法

### 安装所有配置
```bash
./install.sh
```

### 安装 nvim 插件
```bash
# 默认，首次启动自动安装
./nvim/install.sh

# 立即安装所有插件
./nvim/install.sh --with-plugins
```
