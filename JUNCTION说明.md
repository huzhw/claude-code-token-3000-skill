# JUNCTION 说明 — token-3000

> 本目录已与全局 skill 目录建立 junction，**实时双向同步，改哪边都一样**。

## 指向关系

| 项 | 路径 |
|----|------|
| 全局路径（junction） | `C:\Users\Administrator\.claude\skills\token-3000` |
| 实际目录（F 仓库） | `F:\idea-workspase-skills\token-3000` |
| 创建日期 | 2026-08-02 |

## 说明

- 全局目录是指向 F 仓库的 junction，两侧是**同一个目录**，不是副本。
- 修改 F 仓库，全局立刻生效；在全局路径下改文件，F 仓库同步变化。
- 日常维护只改 F 仓库（git 提交推送后全局自动一致），**不需要手动复制同步**。

## 检查是否正常

```bash
cmd /c dir "C:\Users\Administrator\.claude\skills" | findstr token-3000
```

正常应显示 `<JUNCTION>  ...  token-3000`。

## 回滚方法（恢复成独立副本）

```bat
rd "C:\Users\Administrator\.claude\skills\token-3000"
xcopy "F:\idea-workspase-skills\_skills_backup_20260802\token-3000" "C:\Users\Administrator\.claude\skills\token-3000" /E /I /Y
```

> 注意：`rd` 不要加 `/s`，否则可能递归进 F 源目录。

## 本 skill 特殊差异

- 全局原目录是**独立 git checkout**（自带 `.git`，共 38 个文件），与 F 仓库不是同一份；junction 后以 F 仓库为准。
- 全局那份 `.git` 已随目录删除并完整备份。
- README.md 以 F 仓库版本为准（F 07-31 更新，全局 07-26 旧版）。
- 备份位置：`F:\idea-workspase-skills\_skills_backup_20260802\token-3000`（38 个文件）。
