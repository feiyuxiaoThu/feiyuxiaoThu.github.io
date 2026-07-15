---
title: "Windows PowerShell 现代化终端：从零配置到 CLI 工具全指南"
date: 2026-07-14T12:00:00+08:00
tags:
  - Windows
  - PowerShell
  - 终端
  - CLI工具
categories:
  - 工具教程
description: "在一台全新 Windows 上，从零复刻一套 PowerShell 7 + Starship + 一整套 CLI 增强工具的现代化终端，并掌握它们日常用法。"
---

# Windows PowerShell 现代化终端：从零配置到 CLI 工具全指南

> 环境：PowerShell 7 + Windows Terminal + Scoop + Nerd Font（如 Cascadia Code NF）。所有工具均通过 `scoop install` 安装，并写入 PowerShell profile 自动生效。
> 目标：在一台全新的 Windows 电脑上，复刻一套「PowerShell 7 + Starship 美化 + 一整套 CLI 增强工具」的终端环境，并说明每个工具怎么用。
> 本文档不含任何个人信息、账号或密钥；文中出现的盘符 / 路径均为**示例**，请按你自己的环境替换。

---

## 这套环境包含什么

| 类别 | 工具 | 作用 |
|------|------|------|
| 包管理 | **Scoop** | Windows 命令行包管理器 |
| 提示符 | **Starship** | 两行美化提示符（Git/耗时/语言版本等） |
| 字体 | **Nerd Font**（如 Cascadia Code NF） | 让图标正常显示 |
| 文件管理 | **Yazi** / **Glow** | 终端文件管理器 / Markdown 渲染 |
| 跳转 | **zoxide** | 智能 `cd`（`z foo` 秒跳） |
| 列表/查看 | **eza**（接管 `ls`）/ **bat**（接管 `cat`） | 彩色列表 / 语法高亮 |
| 查找 | **fd** / **ripgrep** / **fzf** | 文件名 / 全文 / 模糊查找 |
| 数据 | **jq** / **yq** | JSON / YAML 处理 |
| Git | **delta**（美化 diff）/ **lazygit** | Git 体验增强 |
| 监控 | **bottom**（btm） | 终端任务管理器 |
| 历史 | **atuin** | 增强命令历史（`Ctrl+R`） |
| MIME | **file** | 供 Yazi 识别文件类型 |
| 分屏 | Windows Terminal 窗格 /（可选）zellij | 终端分屏 |

---

## 一、环境搭建（复刻步骤）

### 步骤 1：安装 Nerd Font（必做，否则图标是方块）

方式 A（推荐，scoop）：
```powershell
scoop bucket add nerd-fonts
scoop install CascadiaCode-NF
```
方式 B：手动下载 `Cascadia Code NF` 并安装。

装完后，打开 **Windows Terminal → 设置 → 配置文件 → PowerShell → 外观 → 字体**，改为 `Cascadia Code NF`（或任意 NF 字体），保存。

### 步骤 2：安装 Scoop

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
irm get.scoop.sh | iex
```
安装完成后**重开一个 PowerShell**（让 Scoop 的 shims 目录进入 PATH）。

### 步骤 3：一键安装全部工具

```powershell
scoop bucket add extras
scoop install starship yazi glow `
  zoxide eza fd bat ripgrep delta jq yq lazygit bottom atuin `
  fzf less file psfzf
```
> `psfzf`、`lazygit` 在 `extras` bucket，所以上面先 `scoop bucket add extras`。
> 若某次安装因单个包失败而整体中断，可单独再 `scoop install <包名>` 补齐。

### 步骤 4：配置 Git 使用 delta 美化 diff

```powershell
git config --global core.pager "delta"
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.line-numbers true
git config --global interactive.diffFilter "delta --color-only"
```

### 步骤 5：写入 PowerShell profile

把下方 **附录 A** 的完整内容写入文件：
```
# 路径示意（你的用户名不同，路径会自动对应）：
%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```
可用记事本/VS Code 打开该文件粘贴，或在 PowerShell 中执行：
```powershell
notepad $PROFILE   # 若提示文件不存在，先 New-Item -Path $PROFILE -Type File
```

### 步骤 6：写入 Starship 配置

把下方 **附录 B** 的完整内容写入：
```
%USERPROFILE%\.config\starship.toml
```
（若 `.config` 目录不存在先创建：`mkdir $env:USERPROFILE\.config`）

### 步骤 7：重启终端并验证

完全关闭所有终端窗口后重开 PowerShell，确认：
```powershell
ls          # 应为 eza 彩色列表（无 "Directory:" 表头）
cat $PROFILE # 应为 bat 高亮
z ~         # 应能跳转
Ctrl+R      # 应弹出 atuin 历史搜索
Ctrl+T      # 应弹出 fzf 文件选择
Alt+C       # 应弹出 fzf 目录选择
```
如某命令找不到，重开终端让 PATH 刷新；或 `scoop reset <包名>`。

---

## 二、过程梳理（我们做了什么 & 为什么）

1. **基础美化**：安装 Starship 并在 profile 里 `starship init powershell`，得到两行提示符。
2. **Yazi 预览修复**：Windows 默认无 `file` 命令，Yazi 无法识别 MIME 类型。通过 `scoop install file` 让 `file` 进入 PATH，Yazi 自动识别，无需设置 `YAZI_FILE_ONE`。（备选方案：用 Git 自带的 `file.exe`，设环境变量 `YAZI_FILE_ONE` 指向 `C:\Program Files\Git\usr\bin\file.exe`。）
3. **CLI 增强套件**：装 `zoxide/eza/fd/bat/ripgrep/delta/jq/yq/lazygit/bottom/atuin`，并在 profile 中：
   - 用 `Remove-Item Alias:ls/cat/cd` 解除 PowerShell 内置别名遮蔽，再用 `function` 把 `ls→eza`、`cat→bat`、`cd` 智能跳转接管。
   - `zoxide init` 包裹 Starship 的 `prompt`（兼容）；`atuin init` 只接管 `Ctrl+R`/`↑`（不碰 prompt）。
4. **fzf 模糊查找**：装 `fzf` + `PsFzf`，`Ctrl+T` 插入文件、`Alt+C` 跳目录；刻意**不**占用 `Ctrl+R`（留给 atuin），避免冲突。
5. **git delta**：全局 `core.pager` 设为 `delta`，并装 `less` 提供分页滚动。

> 关键经验：PowerShell 里 `ls`/`cat`/`cd` 原本是**别名**，直接 `function` 会被别名遮蔽，必须先用 `Remove-Item Alias:` 移除再定义函数；多个工具都要 hook `prompt` 时，需确认它们互相包裹/共存而非互相覆盖。

---

## 三、工具使用指南

### 0. 快速开始

1. **重开 PowerShell / Windows Terminal**（让 profile 与 PATH 生效）。
2. 直接体验：
   - `ls` 看到彩色带图标列表 → eza 已接管
   - `cat 某个文件` 看到语法高亮 → bat 已接管
   - `z` + 空格 + 目录名片段 → 跳转到常去目录（zoxide）
   - `Ctrl+R` / `↑` → 搜索历史（atuin）
   - `Ctrl+T` → 模糊选文件插入命令行（fzf）
   - `Alt+C` → 模糊选目录并 `cd`（fzf）

### 1. 提示符 / 外观

#### starship（已配置，无需手动调用）
- 美化后的两行提示符，显示：系统图标、用户@主机、目录、Git 分支/状态、语言版本、命令耗时、时间。
- 配置文件：`~/.config/starship.toml`，改完即时生效（新开终端）。

#### Nerd Font
- eza / starship 的图标需要 Nerd Font；若看到方块，去 Windows Terminal 设置把字体改成 `Cascadia Code NF` 或 `MesloLGM NF`。

### 2. 文件管理器

#### yazi（终端文件管理器）
```powershell
yazi            # 启动，进入后可用方向键/鼠标操作
yazi 目录路径    # 打开指定目录
```
常用快捷键（进入 yazi 后）：

| 键 | 作用 |
|----|------|
| `h` / `←` `l` / `→` | 上级 / 进入目录或打开文件 |
| `j` / `k` 或 `↑` `↓` | 上下移动 |
| `gg` / `G` | 首 / 尾 |
| `Space` | 多选 |
| `y` | 复制，`x` 剪切，`p` 粘贴 |
| `d` | 删除 |
| `r` | 重命名 |
| `/` | 搜索 |
| `:` | 命令模式 |
| `q` | 退出 |

> 已通过 scoop 安装独立 `file` 命令，yazi 右侧预览/修改文本文件正常工作。

### 3. 目录跳转

#### zoxide（智能 `cd`）
```powershell
z foo          # 跳到曾经去过、且名字匹配 foo 的目录
z foo bar      # 多关键词匹配
zi             # 交互式模糊列表选择目录
cd foo         # 已增强：真实路径直接用 cd，否则交给 z 模糊跳转
cd             # 回到用户主目录
```
- 每当你用 `cd`/在目录间移动，zoxide 会自动记录；去过的目录越多，`z` 越聪明。

### 4. 列表 / 查看 / 查找

#### eza（替代 ls，已接管 `ls`）
```powershell
ls              # 彩色列表（带图标，目录在前）
ll              # 详细列表：权限/大小/时间 + git 状态
la              # 含隐藏文件
lt              # 树形展示
eza -la --icons --git --tree --level=2   # 自行组合参数
```

#### bat（替代 cat，已接管 `cat`）
```powershell
cat 文件.py      # 语法高亮 + 行号查看
bat 文件.py      # 同上（直接调 bat 可带分页）
bat -p 文件      # 纯文本（无装饰）
bat --list-themes # 查看主题；bat --theme=xxx 指定
```

#### fd（替代 find，文件查找）
```powershell
fd                # 列出当前目录所有文件/目录
fd 名字            # 按名称模糊查找
fd -e md          # 只找 .md 文件
fd -t d 名字       # 只找目录
fd 名字 -x ls {}   # 对每个结果执行命令（{} 占位）
```

#### ripgrep / rg（极速全文搜索）
```powershell
rg 关键词                 # 在当前目录递归搜索
rg 关键词 -n              # 显示行号
rg 关键词 -i              # 忽略大小写
rg 关键词 --type py       # 只在 .py 中搜
rg 关键词 -l              # 只列出匹配的文件名
rg "func \w+" -r "def $1" # 正则替换预览
```

#### fzf + PsFzf（模糊查找，已集成）
```powershell
# 以下为 PSReadLine 快捷键（在输入命令时使用）：
Ctrl+T        # 弹出模糊列表选文件，选中后把路径插入命令行
Alt+C         # 弹出模糊列表选目录，回车即 cd 过去
# 也可在命令行直接调用：
fzf                       # 列出当前目录文件供选择
fd -t f | fzf             # 用 fd 找文件再交给 fzf 选
history | fzf             # 配合历史做模糊筛选
```

### 5. 数据处理

#### jq（JSON）
```powershell
jq . file.json            # 格式化输出
jq '.name' file.json      # 取字段
jq '.items[] | .id' file.json
cat file.json | jq '.users | length'
```

#### yq（YAML / XML / JSON，mikefarah 版）
```powershell
yq '.name' file.yaml      # 取字段
yq -i '.port = 8080' file.yaml   # 就地修改
yq -o=json file.yaml      # 转 JSON 输出
```

### 6. Git 相关

#### delta（git diff 美化，已全局配置）
```powershell
git diff                  # 自动走 delta：彩色、行号、并排可选
git show                  # 同样美化
# 若想并排：
git config --global delta.side-by-side true
```
> 滚动依赖 `less`（已装）。`git diff` 后按 `q` 退出分页。

#### lazygit（Git 终端图形界面）
```powershell
lazygit          # 在当前 git 仓库目录启动
```
常用键：

| 键 | 作用 |
|----|------|
| `↑` `↓` | 选文件 / 提交 |
| `Tab` | 在 文件/提交/分支 面板间切换 |
| `a` | 暂存（stage）/ 取消暂存 |
| `c` | 提交（下方输入消息，`Esc` 确认） |
| `p` | 推送，`P` 拉取 |
| `o` | 打开文件 |
| `?` | 帮助 |
| `q` | 退出 |

### 7. 系统监控

#### bottom / btm（终端任务管理器）
```powershell
btm               # 启动，默认显示 CPU/内存/网络/进程
btm -b            # 只显示进程列表
```
快捷键：`1~4` 切换各图表显隐，`f` 筛选进程，`q` 退出。

### 8. 命令历史

#### atuin（已集成，接管 `Ctrl+R` / `↑`）
```powershell
Ctrl+R           # 打开历史搜索（模糊匹配，支持多维筛选）
↑                # 同上（在空命令行时）
atuin search     # 直接打开搜索界面
atuin history    # 文本列表查看
```
- 默认本地存储，不联网。想跨机器同步可 `atuin login` / `atuin sync`（需注册 atuin.sh 账号，可选）。

### 9. 终端分屏

PowerShell 自身不分屏，用下面两种方式之一：

#### 方案 A：Windows Terminal 自带窗格（推荐，零配置）

| 快捷键 | 作用 |
|--------|------|
| `Alt+Shift` + `+` | 竖直分屏（右新窗格） |
| `Alt+Shift` + `-` | 水平分屏（下新窗格） |
| `Alt` + `←/→/↑/↓` | 在窗格间移动焦点 |
| `Ctrl+Shift+W` | 关闭当前窗格 |
| `Ctrl+Shift+D` | 复制当前窗格 |

#### 方案 B：zellij（shell 内多路复用，会话可持久化）
```powershell
scoop install zellij     # 本机未装，需要可装
zellij                   # 启动，默认带底部标签栏
zellij attach            # 重连之前断开的会话（关终端也不丢）
```
快捷键（先按 `Ctrl+o` 进入指令前缀）：

| 组合 | 作用 |
|------|------|
| `Ctrl+o` 然后 `s` | 水平分屏 |
| `Ctrl+o` 然后 `v` | 竖直分屏 |
| `Ctrl+o` 然后 `h/j/k/l` | 切换窗格 |
| `Ctrl+o` 然后 `z` | 最大化/还原窗格 |
| `Ctrl+o` 然后 `d` | 脱离会话（后台保留） |
| `Ctrl+o` 然后 `q` | 关闭窗格 |

### 10. Markdown 预览

#### glow
```powershell
glow README.md           # 在终端渲染 Markdown
glow .                   # 列出当前目录可渲染的 md
glow README.md -p        # 分页查看
```

---

## 四、快捷键速查

| 快捷键 / 命令 | 工具 | 作用 |
|---------------|------|------|
| `ls` `ll` `la` `lt` | eza | 列目录（彩色/详细/隐藏/树） |
| `cat 文件` | bat | 高亮查看文件 |
| `z 片段` / `zi` | zoxide | 智能跳转目录 |
| `cd 片段` | zoxide+cd | 增强版 cd |
| `fd 名` | fd | 按名找文件/目录 |
| `rg 关键词` | ripgrep | 全文搜索 |
| `jq` / `yq` | jq/yq | 处理 JSON / YAML |
| `git diff` | delta | 美化 diff |
| `lazygit` | lazygit | Git TUI |
| `btm` | bottom | 系统监控 |
| `Ctrl+R` / `↑` | atuin | 历史搜索 |
| `Ctrl+T` | fzf | 模糊选文件插入命令行 |
| `Alt+C` | fzf | 模糊选目录并 cd |
| `yazi` | yazi | 终端文件管理器 |
| `glow 文件` | glow | 渲染 Markdown |
| `Alt+Shift++` / `-` | WT | 终端分屏 |

---

## 五、配置文件参考

### 附录 A：PowerShell profile 完整内容

> 文件路径：`%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

```powershell
Invoke-Expression (&starship init powershell)

# ===== CLI 增强工具集成 =====

# zoxide: 智能目录跳转（z foo），并让 cd 也变智能
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue
function cd {
    $target = $args -join ' '
    if ($args.Count -eq 0) {
        Set-Location
    } elseif (Test-Path -LiteralPath $target -ErrorAction SilentlyContinue) {
        Set-Location -LiteralPath $target
    } else {
        z @args
    }
}

# atuin: 增强 shell 历史（Ctrl+R / ↑ 搜索历史）
Invoke-Expression (atuin init powershell | Out-String)

# eza 替代 ls / bat 替代 cat（需 Nerd Font 才能正常显示 eza 图标）
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue
function ls { eza --icons --group-directories-first @args }
function ll { eza -la --icons --git @args }
function la { eza -a --icons @args }
function lt { eza --tree --icons @args }

# bat 替代 cat
function cat { bat --paging=never @args }

# fzf + PsFzf: 模糊查找（Ctrl+T 插入文件, Alt+C 跳目录；Ctrl+R 留给 atuin）
$env:PSModulePath = "$env:USERPROFILE\scoop\modules;$env:PSModulePath"
Import-Module PsFzf -ErrorAction SilentlyContinue
if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+t'
    Set-LocationFuzzyEverything
}
```

### 附录 B：Starship 配置完整内容

> 文件路径：`%USERPROFILE%\.config\starship.toml`
> 说明：`[directory.substitutions]` 里的路径为**示例**，请改成你自己的常用目录（如 `C:\Projects`）。

```toml
"$schema" = 'https://starship.rs/config-schema.json'

# ===== 整体布局 =====
format = """
$os\
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$git_metrics\
$git_state\
$python\
$nodejs\
$rust\
$golang\
$docker_context\
$env\
$cmd_duration\
$line_break\
$jobs\
$time\
$character"""

# ===== 换行符 =====
[line_break]
disabled = false

# ===== 系统图标 =====
[os]
disabled = false
style = "bold white"

# ===== 用户名 =====
[username]
style_user = "bold cyan"
style_root = "bold red"
format = "[$user]($style) "
show_always = false

# ===== 主机名 =====
[hostname]
ssh_only = false
style = "bold green"
format = "@[$hostname]($style) "

# ===== 当前目录 =====
[directory]
style = "bold blue"
format = "[$path]($style)[$read_only]($read_only_style) "
truncation_length = 3
truncation_symbol = "…/"
read_only = " 🔒"

[directory.substitutions]
"C:\\Projects" = "📁 Projects"
"C:\\" = "💽 C"

# ===== Git 分支 =====
[git_branch]
symbol = "🌿 "
style = "bold purple"
format = "[$symbol$branch]($style) "

# ===== Git 状态 =====
[git_status]
style = "bold red"
format = '([\[$all_status$ahead_behind\]]($style) )'
conflicted = "="
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
up_to_date = ""
untracked = "?${count}"
stashed = "\\$${count}"
modified = "!${count}"
staged = "+${count}"
renamed = "»${count}"
deleted = "✘${count}"

# ===== Git 提交指标（插入/删除数）=====
[git_metrics]
disabled = true
style = "bold red"
format = "(+$added -$deleted) "

# ===== Git 状态（rebase/merge 等）=====
[git_state]
style = "bold yellow"
format = '[\($state( $progress_current of $progress_total)\)]($style) '

# ===== Python =====
[python]
symbol = "🐍 "
style = "bold yellow"
format = '[$symbol($version )(\($virtualenv\) )]($style)'
detect_extensions = ["py"]
detect_files = ["requirements.txt", "pyproject.toml", "Pipfile", "setup.py", ".python-version"]

# ===== Node.js =====
[nodejs]
symbol = "⬢ "
style = "bold green"
format = "[$symbol($version )]($style)"
detect_extensions = ["js", "mjs", "cjs", "ts"]
detect_files = ["package.json", ".node-version", ".nvmrc"]

# ===== Rust =====
[rust]
symbol = "🦀 "
style = "bold red"
format = "[$symbol($version )]($style)"

# ===== Golang =====
[golang]
symbol = "🐹 "
style = "bold cyan"
format = "[$symbol($version )]($style)"

# ===== Docker =====
[docker_context]
symbol = "🐳 "
style = "bold blue"
format = "[$symbol$context]($style) "
only_with_files = false

# ===== 命令执行时长 =====
[cmd_duration]
min_time = 500
style = "bold yellow"
format = "⏱️ [$duration]($style) "

# ===== 后台任务 =====
[jobs]
symbol = "✦"
style = "bold blue"
format = "[(${symbol}) $number]($style) "
threshold = 1

# ===== 时间 =====
[time]
disabled = false
style = "bold dimmed white"
format = "🕐 [$time]($style) "
time_format = "%H:%M:%S"

# ===== 提示符 =====
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold green)"

# ===== 右侧提示符（光标上方）=====
[fill]
symbol = " "
style = "bold black"

[status]
style = "bold bg-red white"
symbol = "🔥 "
format = '[\[$symbol $status\]]($style) '
disabled = false
```

### 附录 C：Git delta 配置命令（等价写入）

```powershell
git config --global core.pager "delta"
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.line-numbers true
git config --global interactive.diffFilter "delta --color-only"
```

---

## 六、常见问题与排错

- **图标是方块**：终端字体没设 Nerd Font，改 Windows Terminal 配置文件字体为 `Cascadia Code NF`。
- **`ls`/`cat` 仍是旧样式**：profile 未加载或被别名遮蔽，确认 profile 里有 `Remove-Item Alias:ls/cat`，并重开终端。
- **Yazi 预览报 MIME 错误**：确认 `file` 在 PATH（`where file`）；或设环境变量 `YAZI_FILE_ONE` 指向 Git 自带的 `C:\Program Files\Git\usr\bin\file.exe`。
- **`Ctrl+R` 没反应 / 被 fzf 抢走**：本配置中 `Ctrl+R` 归 atuin，fzf 用 `Ctrl+T`/`Alt+C`；若冲突，检查 profile 中 `Set-PsFzfOption` 是否只设了 `-PSReadLineChordProvider 'Ctrl+t'`。
- **想恢复原始 `ls`/`cat`**：注释掉 profile 中对应 `function` 行即可。
- **新增工具后命令找不到**：重开终端让 PATH 刷新；或 `scoop reset <包名>`。
- **atuin 与 fzf 的 `Ctrl+R`**：本配置中 `Ctrl+R` 归 atuin，fzf 用 `Ctrl+T` / `Alt+C`，互不冲突。
