# Windows RDP Audit（RdpMon 简体中文修改版）

这是一个用于 Windows 远程桌面（RDP）审计的桌面工具，可在本机持续记录并查看 RDP 连接活动。

本仓库是 [Cameyo/RdpMon](https://github.com/cameyo/rdpmon) 的非官方修改版，基于上游提交 `f9267209cf6d4a28edb9b3908c92e936b5708b06`。本项目与 Cameyo 无隶属或官方认可关系。

## 当前功能

- 按来源 IP 汇总连接尝试
- 查看成功次数、失败次数、首次尝试和最后尝试时间
- 查看历史及当前 RDP 会话、登录账号、登录时间和持续时间
- 查看会话内运行的进程
- 通过同一可执行文件安装后台 Windows 服务并打开管理界面
- 提供纯简体中文界面

> 本项目当前是 Windows 桌面程序，并非 Web 管理页面。后续计划可在现有审计数据基础上增加本地 Web 查询界面。

## 工作原理

后台服务订阅 Windows 事件日志中的远程桌面和安全审计事件，提取来源 IP、账号、会话与登录结果等信息，并将记录保存在本机 LiteDB 数据库中。桌面界面读取数据库并实时展示汇总数据。

准确记录登录成功或失败依赖 Windows 相应审计策略和事件日志已启用。首次运行需要管理员权限，以便安装和启动 `RDP Monitor` Windows 服务。

## 构建

环境要求：

- Windows
- Visual Studio 2022 或 Build Tools（含 MSBuild）
- NuGet
- .NET Framework 4.6.1 目标组件；也可由 NuGet 恢复 `Microsoft.NETFramework.ReferenceAssemblies.net461`

在仓库根目录执行：

```powershell
nuget restore .\RdpMon.sln -ConfigFile .\NuGet.Config
msbuild .\RdpMon.sln /t:Build /p:Configuration=Release /p:Platform="Any CPU" `
  /p:TargetFrameworkRootPath=".\packages\Microsoft.NETFramework.ReferenceAssemblies.net461.1.0.3\build\"
```

汉化冒烟测试：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\LocalizationSmokeTest.ps1
```

## 来源与许可证

项目保留完整上游 Git 历史和原始 [`LICENSE`](LICENSE)。源代码依照 MIT License 使用、修改和再发布；修改说明见 [`NOTICE`](NOTICE)，第三方依赖许可见 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)。

发布修改版时必须保留原 MIT 版权和许可声明。`RdpMon`、`Cameyo` 及相关名称不因 MIT 许可而成为本项目的商标授权。
