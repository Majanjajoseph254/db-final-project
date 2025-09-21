# GitHub Commands Guide

This guide contains all the essential Git and GitHub commands you'll need to manage your repositories effectively.

## 📋 Table of Contents

- [Initial Setup](#initial-setup)
- [Basic Git Operations](#basic-git-operations)
- [Branch Management](#branch-management)
- [Remote Repository Management](#remote-repository-management)
- [Collaboration Commands](#collaboration-commands)
- [Troubleshooting](#troubleshooting)
- [Useful Tips](#useful-tips)

---

## 🚀 Initial Setup

### Configure Git User Information
```bash
# Set your name (appears in commits)
git config --global user.name "Your Name"

# Set your email (appears in commits)
git config --global user.email "your.email@example.com"

# Check current configuration
git config --list
```

### Initialize a New Repository
```bash
# Initialize git in current directory
git init

# Initialize git in a new directory
git init my-project-name
```

---

## 📁 Basic Git Operations

### Adding and Committing Files
```bash
# Check status of files
git status

# Add specific file
git add filename.txt

# Add all files in current directory
git add .

# Add all files (including subdirectories)
git add -A

# Add files interactively (choose what to add)
git add -i

# Commit with message
git commit -m "Your commit message here"

# Commit with detailed message (opens editor)
git commit

# Add and commit in one command (only for tracked files)
git commit -am "Your commit message"
```

### Viewing History and Changes
```bash
# View commit history
git log

# View commit history in one line per commit
git log --oneline

# View commit history with graph
git log --oneline --graph

# View changes in working directory
git diff

# View changes in staged files
git diff --staged

# View changes between commits
git diff commit1 commit2

# View file changes in a specific commit
git show commit-hash
```

### Undoing Changes
```bash
# Unstage a file (remove from staging area)
git reset filename.txt

# Unstage all files
git reset

# Discard changes in working directory (CAREFUL!)
git checkout -- filename.txt

# Discard all changes in working directory (CAREFUL!)
git checkout -- .

# Amend last commit (change message or add files)
git commit --amend -m "New commit message"

# Revert a specific commit (creates new commit)
git revert commit-hash

# Reset to previous commit (CAREFUL - loses history!)
git reset --hard commit-hash
```

---

## 🌿 Branch Management

### Creating and Switching Branches
```bash
# List all branches
git branch

# List all branches (including remote)
git branch -a

# Create new branch
git branch new-branch-name

# Create and switch to new branch
git checkout -b new-branch-name

# Switch to existing branch
git checkout branch-name

# Switch to previous branch
git checkout -

# Delete branch (must be on different branch)
git branch -d branch-name

# Force delete branch (even if not merged)
git branch -D branch-name

# Rename current branch
git branch -m new-branch-name
```

### Merging Branches
```bash
# Merge branch into current branch
git merge branch-name

# Merge with no fast-forward (creates merge commit)
git merge --no-ff branch-name

# Abort a merge in progress
git merge --abort
```

---

## 🌐 Remote Repository Management

### Adding and Managing Remotes
```bash
# List remote repositories
git remote -v

# Add remote repository
git remote add origin https://github.com/username/repository.git

# Add remote with custom name
git remote add upstream https://github.com/original/repository.git

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin new-name

# Update remote URL
git remote set-url origin https://github.com/username/new-repository.git
```

### Pushing and Pulling
```bash
# Push to remote repository (first time)
git push -u origin main

# Push to remote repository
git push origin main

# Push all branches
git push --all origin

# Push with tags
git push --tags

# Pull latest changes
git pull origin main

# Fetch changes without merging
git fetch origin

# Fetch and merge
git fetch origin && git merge origin/main

# Clone repository
git clone https://github.com/username/repository.git

# Clone into specific directory
git clone https://github.com/username/repository.git my-project
```

---

## 👥 Collaboration Commands

### Working with Forks
```bash
# Add upstream repository
git remote add upstream https://github.com/original/repository.git

# Fetch upstream changes
git fetch upstream

# Merge upstream changes
git merge upstream/main

# Push to your fork
git push origin main
```

### Pull Requests and Issues
```bash
# Create new branch for feature
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push feature branch
git push origin feature/new-feature

# After PR is merged, clean up
git checkout main
git pull origin main
git branch -d feature/new-feature
```

---

## 🔧 Troubleshooting

### Common Issues and Solutions
```bash
# Fix merge conflicts
# 1. Edit conflicted files manually
# 2. Add resolved files
git add resolved-file.txt
# 3. Complete merge
git commit

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Stash changes temporarily
git stash

# List stashes
git stash list

# Apply stash
git stash apply

# Apply and remove stash
git stash pop

# Remove stash
git stash drop

# Clear all stashes
git stash clear

# Force push (CAREFUL - can overwrite remote history!)
git push --force origin main

# Safe force push (recommended)
git push --force-with-lease origin main
```

### Repository Maintenance
```bash
# Clean untracked files
git clean -f

# Clean untracked files and directories
git clean -fd

# Prune remote branches that no longer exist
git remote prune origin

# Garbage collection
git gc

# Check repository integrity
git fsck
```

---

## 💡 Useful Tips

### Aliases (Shortcuts)
```bash
# Create useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

### Ignore Files
Create a `.gitignore` file in your repository root:
```bash
# Create .gitignore file
touch .gitignore

# Common .gitignore patterns:
echo "*.log" >> .gitignore
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore
echo "*.tmp" >> .gitignore
echo ".DS_Store" >> .gitignore
```

### Tags
```bash
# Create tag
git tag -a v1.0 -m "Version 1.0"

# List tags
git tag

# Push tags
git push origin --tags

# Delete tag
git tag -d v1.0
git push origin :refs/tags/v1.0
```

---

## 🚀 Quick Workflow Examples

### First Time Setup (New Project)
```bash
# 1. Initialize repository
git init

# 2. Add remote
git remote add origin https://github.com/username/repository.git

# 3. Add files
git add .

# 4. First commit
git commit -m "Initial commit"

# 5. Push to GitHub
git push -u origin main
```

### Daily Workflow
```bash
# 1. Check status
git status

# 2. Add changes
git add .

# 3. Commit changes
git commit -m "Descriptive message"

# 4. Push changes
git push origin main
```

### Feature Development
```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes and commit
git add .
git commit -m "Add new feature"

# 3. Push feature branch
git push origin feature/new-feature

# 4. Switch back to main
git checkout main

# 5. Merge feature
git merge feature/new-feature

# 6. Push merged changes
git push origin main

# 7. Delete feature branch
git branch -d feature/new-feature
```

---

## 📚 Additional Resources

- [Official Git Documentation](https://git-scm.com/doc)
- [GitHub Help](https://help.github.com/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [GitHub Desktop](https://desktop.github.com/) - GUI alternative

---

## ⚠️ Important Notes

1. **Always check `git status`** before making changes
2. **Write descriptive commit messages** - they help you and others understand changes
3. **Never force push to shared repositories** without team agreement
4. **Use branches** for feature development
5. **Regular commits** make it easier to track changes and resolve conflicts
6. **Backup important work** before using destructive commands like `git reset --hard`

---

*This guide covers the most commonly used Git and GitHub commands. Keep it handy for your development workflow!*
