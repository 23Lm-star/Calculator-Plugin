# Design（设计）：项目流程升级到 v1.2

## Context and constraints（上下文与约束）

项目已有 `docs/ai-workflow/` v1.0/v1.1 记录，当前工作区存在用户未提交改动；升级必须新增规范目录并保持旧路径不变。

## Alternatives considered（备选方案）

- 原地改造旧目录：会混淆历史版本，不可选。
- 删除旧目录后重建：破坏审计追溯，不可选。
- 新建 `project-docs/` 并更新兼容入口：保留证据、边界清晰，选用。

## Selected approach and trade-offs（选定方案与权衡）

采用新目录作为 v1.2 规范根，旧目录只读保留；代价是短期存在双目录，需要入口文档明确规则。

## Components and ownership（组件与职责）

`project-docs/agent.md` 负责流程规则；项目清单声明运行时/测试根；质量配置声明门禁；回归清单声明完整行为；迁移任务记录批准、证据和回滚引用。

## Interfaces and data flow（接口与数据流）

`docs/agent.md` -> `project-docs/agent.md` -> `project-manifest.yaml` -> 任务记录与证据目录。旧任务通过迁移记录引用，不复制或改写。

## Error handling and recovery（错误处理与恢复）

验证失败时保持旧目录和源码不变，依据迁移记录恢复 `docs/agent.md` 入口并移除本次新增的 v1.2 记录。

## Security and authorization impact（安全与授权影响）

无权限、密钥、外部服务或运行时数据变化；流程升级本身已取得用户精确批准。

## Testing strategy（测试策略）

校验版本字段、必需文件、路径边界、历史文件哈希和 Git 变更集合；不运行业务构建以避免超出流程迁移范围。

## Rollback strategy（回滚策略）

以 `migrations/v1-1-to-v1-2-20260914.yaml` 为回滚索引，恢复入口并保留迁移证据。

## User confirmation（用户确认）

- Status（状态）：`CONFIRMED`
- Decision event（决策事件）：`goal-approval-20260914`
