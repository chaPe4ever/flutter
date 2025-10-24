# Generate a GitHub Pull Request

Quick, practical steps and a compact PR template you can use.

## 1. Create a branch
```bash
git fetch origin
git checkout -b feat/short-description
```

## 2. Make changes and commit
```bash
git add .
git commit -m "feat: short description of change"
```

If needed, squash or amend before pushing:
```bash
git commit --amend --no-edit
git rebase -i main
```

## 3. Push branch
```bash
git push --set-upstream origin feat/short-description
```

## 4. Open the PR
- Web: open the repository on GitHub → Compare & pull request.
- CLI (GitHub CLI):
```bash
gh pr create --base main --head feat/short-description --title "feat: short description" --body-file ./pr-body.md
```
- hub:
```bash
hub pull-request -b main -h feat/short-description -m "feat: short description"
```

## 5. PR checklist (add to PR description)
- Summary: one-sentence description of intent.
- Changes: bullet list of important changes.
- Testing: how to reproduce and verify.
- CI: all checks passing (or note why failing).
- Migration/DB: list required migrations or config changes.
- Breaking changes: call out explicitly.
- Related issues: fixes/closes #NNN
- Reviewers/Assignees: tag relevant people.

## 6. Example PR body
```md
Summary
- Short summary.

Changes
- Implement feature X
- Refactor Y
- Add tests for Z

Testing
1. Run `flutter test`
2. Start app and verify A -> B

CI
- All checks green

Related
- Fixes #123
```

## 7. Tips
- Use clear branch names: feat/, fix/, chore/.
- Keep PRs small and focused.
- Add reviewers, labels, and a milestone if relevant.
- Use `.github/PULL_REQUEST_TEMPLATE.md` for consistent PRs if exists.

