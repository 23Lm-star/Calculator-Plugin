# 冻结候选独立审计证据

```powershell
git diff --stat HEAD^ HEAD
git diff --name-only HEAD^ HEAD
git diff --check HEAD^ HEAD
git diff --name-only HEAD^ HEAD -- src tests calculator.pro docs/ai-workflow/
git diff --name-only HEAD^ HEAD -- calculator.pro '*.pri' '*.pro.user'
git show HEAD:project-docs/tasks/project-workflow-upgrade-v1-2-20260914/approval-events.ndjson
```

审计对象 `3dd1fa4a082f607be051e9e352bf833fa67e2546` 全部断言通过。
