# dwmblocks

Modular status bar for dwm.

## 安装

```sh
cd dwmblocks
./install.sh
```

## 配置

编辑 `blocks/config.h` 来添加或修改模块:

- `command`: 自定义 shell 命令 (设为 NULL 使用内置)
- `interval`: 更新间隔(秒)
- `signal`: 信号编号 (用于 USR1 信号触发更新)
- `format`: 内置模块名称 ("bat", "mem", "cpu", "datetime")

内置模块会读取系统信息并输出 lemonbar 兼容的颜色代码。

## 运行

启动 dwmblocks:
```sh
dwmblocks &
```

dwm 会通过 FIFO `/tmp/dwmblocks_fifo` 读取状态。

## 自定义模块

在 `blocks/` 目录下添加新的 `.c` 文件，实现输出函数，例如:
```c
void mymodule(char *output) {
    snprintf(output, 256, "%%{F#color}%%{T2}%%{T1}icon%%{F-} value");
}
```

然后在 `config.h` 中添加。