# Task Manifest | M01-F03

```yaml
internal_id: m01-f03-release-delivery-v1
human_name: 发布交付物生成与部署脚本化
workflow_version: v1.1
task_card_version: v1.2
status: development_in_progress
stage: development_repository_payload
branch: codex/release-delivery-v1.0
base_branch: integration
base_commit: 1ce0e9a
goal_source: 任务卡.md#confirmed-goal
allowed_paths:
  - scripts/release/
  - release/
  - docs/ai-workflow/
  - .gitignore (only if an explicit payload exception is needed)
reports:
  task_card: 任务卡.md
  development: 开发报告.md
  independent_test: 独立测试报告.md
  independent_audit: 独立审计报告.md
evidence:
  development: evidence/development/repository-payload-validation.md
  independent_test: evidence/independent-test/independent-validation-results.json
repair_cycles:
  - findings: P1 ZIP whitelist and path leakage; P2 parser evidence coverage
    result: passed independent test and audit on 2026-08-07
  - findings: source-tree installer previously required an extracted external Installer ZIP
    result: superseded by repository-tracked release/Payload.zip delivery goal on 2026-08-08
approval_decisions: []
integration:
  candidate_feature_commit: d45411457b7e88896d170d625c23e6e3d977ac5e
  target_branch: integration
  target_commit: 1ce0e9a46700fb80e0389457c2dc0452864d0003
  merge_result: conflict_free_no_commit_candidate
  regression_result: blocked_insufficient_disk_space
  report: integration-report.md
repository_delivery:
  payload: release/Payload.zip
  end_user_entrypoint: scripts/release/Install-Calculator.cmd
  fallback_entrypoint: scripts/release/Install-Calculator.ps1
  maintainer_rebuild: scripts/release/Package-Release.ps1
  supersedes: external Installer ZIP as the end-user delivery mechanism
known_limitations:
  - 未执行真实 VC 运行库安装，以避免在开发机上修改系统运行库；使用受控的进程启动模拟覆盖退出码分支。
repair_verification:
  payload_index_state: staged_only
  payload_sha256: 87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101
  ignore_check_exit: 1
  controlled_clean_clone_exit: 0
  controlled_clean_clone_payload_present: false
  controlled_clean_clone_cmd_exit: 1
  result: rejected_pending_authorized_coherent_candidate_commit
next_session_prompt: |
  $development-os 独立测试 仓库源码直接安装交付 docs/ai-workflow/tasks/m01-f03-release-delivery-v1/
```
