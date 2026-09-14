# v1.2 流程升级验证证据

- 验证时间：2026-09-14
- 项目：`wangchenyang-calculator`（王晨扬的计算器）
- 当前分支：`codex/release-delivery-v1.0`
- 基线提交：`68ab54439f8e859779844ef4e6723f24e3545d25`
- 用户批准：`conf-20260914-workflow-upgrade`

## 检查结果

| 检查 | 结果 | 证据 |
| --- | --- | --- |
| `docs/agent.md` 指向 `project-docs/` | PASS（通过） | 入口文件新增流程版本段落 |
| 项目清单声明 `workflow_version: v1.2` | PASS（通过） | `project-docs/project-manifest.yaml` |
| 质量配置与回归清单存在 | PASS（通过） | `quality-profile.yaml`、`regression/功能回归清单.yaml` |
| 历史 `docs/ai-workflow/` 保留 | PASS（通过） | 旧目录仍存在；迁移前哈希写入迁移清单 |
| 源码、测试和工程文件未纳入升级范围 | PASS（通过） | 允许路径仅 `docs/agent.md`、`project-docs/` |
| 用户原有未提交改动未覆盖 | PASS（通过） | 基线快照记录于迁移清单；未修改其所在旧目录文件 |
| 业务构建/回归测试 | NOT_APPLICABLE（本次不适用） | 本次任务范围仅含流程文档，按范围证据不执行业务门禁；批准人：王晨扬。下一项业务任务按 v1.2 质量门禁执行 |

## 版本与路径结论

迁移后的规范入口、项目清单、质量配置和回归清单均使用 `v1.2`。旧 v1.0/v1.1 任务记录未被删除或改写；新增内容只位于 `project-docs/`，业务源码行为不受影响。本报告是开发阶段的迁移验证证据，不代替后续独立测试与独立审计。

## 回滚

若发现迁移问题，依据 `project-docs/migrations/v1-1-to-v1-2-20260914.yaml` 恢复 `docs/agent.md` 的旧入口，移除本次新增 `project-docs/` 记录并保留验证证据；不得触碰源码、测试和用户原有改动。
