# xdbg_mcp

x64dbg + MCP 调试器通道。在 Windows 机上部署 x64dbg 并挂上 MCP Server 插件，
从 Linux 机通过 SSH 端口转发直连 MCP，用 LLM 驱动动态调试/逆向分析。

## 组成

- `config.yaml` —— 部署/连接配置（占位符替换成你的 Windows 机信息）
- `scripts/xdbg_mcp.ps1` —— Windows 侧 MCP 调用助手（自动读 AuthToken，k=v 传参）
- `scripts/xdbg_launch.ps1` —— 计划任务：把 x64dbg GUI 拉进 console session 启动
- `scripts/xdbg_notepad.ps1` —— notepad 冒烟脚本（验证 attach/pause/反汇编全链路）
- `scripts/wxrestart.ps1` —— 调试杀进程后用计划任务重启目标进程（示例）

## 用法

1. Windows 机装 x64dbg + x64dbg-MCP-Server 插件
2. 替换 config.yaml 里的 SSH 占位符
3. 建计划任务跑 `xdbg_launch.ps1`（GUI 必须在有活跃桌面的 session 跑）
4. Linux 侧 `ssh -L 19094:127.0.0.1:9094 <win机>` 建隧道
5. `curl http://127.0.0.1:19094/` 调 MCP 工具（token 从 mcp_config.json 读）

## 铁律

x64dbg 没有 detach，StopDebug = 杀被调试进程。attach 长驻进程前先想清楚代价。

## 赞助

如果这个项目对你有用，欢迎赞助支持一下，请我喝杯奶茶：

![sponsor](assets/sponsor.jpg)

—— 幻日出品
