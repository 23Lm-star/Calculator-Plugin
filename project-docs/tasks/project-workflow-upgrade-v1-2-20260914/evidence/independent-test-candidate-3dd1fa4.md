# 冻结候选独立测试命令证据

```powershell
git rev-parse HEAD
git rev-parse HEAD^
git diff --name-only HEAD^ HEAD
git diff --quiet HEAD^ HEAD -- docs/ai-workflow/
git diff --quiet HEAD^ HEAD -- src tests calculator.pro
git cat-file -e HEAD:<required-path>
git show HEAD:project-docs/project-manifest.yaml
git show HEAD:project-docs/tasks/project-workflow-upgrade-v1-2-20260914/manifest.yaml
git show HEAD:docs/agent.md
```

所有命令断言通过；候选提交哈希为 `3dd1fa4a082f607be051e9e352bf833fa67e2546`。
