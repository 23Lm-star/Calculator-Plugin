# 本地实际合并证据

| 时点 | 命令 | 退出码 | 结果 |
| --- | --- | --- | --- |
| 合并前 | `git branch --verbose --no-abbrev` | 0 | `integration` 指向 `e2ce7e60459f80f54475b9379d9dcc31555f6afa`；候选分支指向 `36f86cc` |
| 合并前 | `git status --short --branch` | 0 | 功能分支工作区干净；候选工作树中的无提交合并无冲突 |
| 实际合并 | `git switch integration && git merge --no-ff --no-edit codex/m01-f01-calculator-v1` | 0 | 创建 `1df9d61` |
| 合并后 | `git status --short --branch` | 0 | `## integration`，无未提交文件 |

未执行 `git push`、`integration -> main`、标签创建或部署。
