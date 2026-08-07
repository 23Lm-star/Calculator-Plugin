# Task Manifest | M01-F03

```yaml
internal_id: m01-f03-release-delivery-v1
human_name: 发布交付物生成与部署脚本化
workflow_version: v1.1
task_card_version: v1.1
status: candidate_regression_blocked
stage: local_integration_candidate_blocked
branch: codex/release-delivery-v1.0
base_branch: integration
base_commit: 1ce0e9a
goal_source: 任务卡.md#confirmed-goal
allowed_paths:
  - scripts/release/
  - release/
  - artifacts/release/
  - docs/ai-workflow/
reports:
  task_card: 任务卡.md
  development: 开发报告.md
  independent_test: 独立测试报告.md
  independent_audit: 独立审计报告.md
evidence:
  development: evidence/development/release-validation.md
  vc_redist_validation: evidence/development/vc-redist-install-validation.md
  independent_test: evidence/independent-test/independent-validation-results.json
repair_cycles:
  - findings: P1 ZIP whitelist and path leakage; P2 parser evidence coverage
    result: passed independent test and audit on 2026-08-07
approval_decisions: []
integration:
  candidate_feature_commit: d45411457b7e88896d170d625c23e6e3d977ac5e
  target_branch: integration
  target_commit: 1ce0e9a46700fb80e0389457c2dc0452864d0003
  merge_result: conflict_free_no_commit_candidate
  regression_result: blocked_insufficient_disk_space
  report: integration-report.md
known_limitations:
  - 未执行真实 VC 运行库安装，以避免在开发机上修改系统运行库；使用受控的进程启动模拟覆盖退出码分支。
next_session_prompt: |
  $development-os 集成 发布交付物生成与部署脚本化 docs/ai-workflow/tasks/m01-f03-release-delivery-v1/
```
