# 独立测试命令证据

- 执行日期：2026-09-14
- 执行角色：独立测试（只读校验；报告写入任务证据目录）
- 结果：`BLOCKED`（阻塞）

## 执行命令

```powershell
git status --short
git branch --show-current
git rev-parse HEAD
git diff --name-status
git diff --cached --name-status
Get-FileHash -Algorithm SHA256 docs/business-context.md
Get-FileHash -Algorithm SHA256 docs/ai-workflow/任务总览.md
Get-FileHash -Algorithm SHA256 docs/ai-workflow/项目时间流.md
```

## 可复现断言

- `project-docs/project-manifest.yaml` 和任务 `manifest.yaml` 均声明 `workflow_version: "v1.2"`。
- `docs/agent.md` 包含 `project-docs/` 规范入口。
- 三个历史文件的 SHA-256（安全散列）与 `migrations/v1-1-to-v1-2-20260914.yaml` 已登记值一致。
- `docs/ai-workflow/` 存在未提交变更；HEAD 仍为 `68ab54439f8e859779844ef4e6723f24e3545d25`，未形成专用冻结提交。

## 判定

路径、版本和已登记历史哈希检查通过；冻结提交与工作区隔离前提失败，故本节点不得给出通过结论，也不得移交集成。
