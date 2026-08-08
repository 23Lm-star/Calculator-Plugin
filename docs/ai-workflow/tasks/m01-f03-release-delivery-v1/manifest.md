# Task Manifest | M01-F03

```yaml
internal_id: m01-f03-release-delivery-v1
human_name: 发布交付物生成与部署脚本化
workflow_version: v1.1
task_card_version: v1.2
status: candidate_committed_pending_current_integration_merge
stage: current_integration_conflicts_resolved_pending_regression
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
  target_commit: 0b18a4ed285e628a42c7ebe610d90d3b1398619e
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
candidate_verification:
  candidate_commit: b591d6db69cac68e94f7989e113012fc631a15c1
  controlled_clean_clone_exit: 0
  controlled_clean_clone_payload_present: true
  controlled_clean_clone_payload_sha256: 87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101
  controlled_installer_validation_exit: 0
  independent_test: pass
  independent_audit: pass
  real_vc_runtime_executed: false
integration_precheck_rerun:
  date: 2026-08-08
  candidate_commit: b591d6db69cac68e94f7989e113012fc631a15c1
  controlled_clean_clone_exit: 0
  controlled_installer_validation_exit: 0
  assertions_passed: 23
  payload_sha256: 87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101
  full_regression: not_run_pending_explicit_approval
  real_vc_runtime_executed: false
  evidence: evidence/integration/candidate-premerge-rerun-2026-08-08.md
repair_verification_2026_08_08:
  repair_scope:
    - scripts/release/Package-Release.ps1
    - evidence/independent-test/run-independent-validation.ps1
  contract: OutputDirectory writes Payload.zip when PayloadPath is omitted; default remains release/Payload.zip
  isolated_worktree: C:\\tmp\\m01-f03-isolated-20260808-contract
  isolated_base_commit: 1ce0e9a46700fb80e0389457c2dc0452864d0003
  merge_head: b591d6db69cac68e94f7989e113012fc631a15c1
  merge_result: conflict_free_no_commit_no_ff
  diff_check_unstaged_exit: 0
  diff_check_staged_exit: 0
  engine_tests_exit: 0
  independent_release_validation_exit: 0
  engine_tests_sha256: A64C1FD5775E5019751E38062736076401EEF534526F5FE539C457AF9D7015B1
  application_exe_sha256: B1D0576D18B7B07109FF49368EC8BB32CB62DED5924A6AF93CB3597523D0C413
  real_vc_runtime_executed: false
  disk_capacity: access_denied_by_managed_sandbox
  evidence: evidence/integration/repair-isolated-validation-2026-08-08.md
next_session_prompt: |
  $development-os 独立测试 仓库源码直接安装交付 docs/ai-workflow/tasks/m01-f03-release-delivery-v1/
```
