# git命令
## 基础设置
### 用户设置
+ `$ git config --global user.name "Your Name"`
+ `$ git config --global user.email "email@example.com"`

### 初始化仓库
+ `$ git init`
+ Initialized empty Git repository in /Users/learngit/.git/

### 把文件添加到仓库
+ `git add filename`

### 把文件提交到仓库
+ `git commit -m "comment message"`(-am:添加且提提交)

### 添加文件到Git仓库，分两步：
+ 第一步，使用命令git add ，注意，可反复多次使用，添加多个文件；
+ 第二步，使用命令git commit，完成。

### 看结果
+ `git status`

### 看具体修改了什么内容
+ `git diff filename`

### 看历史记录
+ `git log`
+ `git log --pretty=oneline`
+ `git reflog`

### 跳到之前版本
+ 首先，Git必须知道当前版本是哪个版本，在Git中，用HEAD表示当前版本，也就是最新的提交,上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100.
+ `git reset --hard HEAD^`
+ `git reset --hard 3628164`//回到的历史版本号

### 丢弃工作区的修改
+ `git checkout -- filename`//无“--”变成了创建新分支
+ `git reset HEAD filename`//把暂存区的修改撤销掉（unstage），重新放回工作区

### 删除文件
+ `git rm test.txt`
+ `git commit -m "remove test.txt`

## 远程仓库
### 关联一个远程库
+ `git remote add origin git@server-name:path/repo-name.git`
+ `git push -u origin master`//第一次推送内容

### 克隆仓库
+ `git clone git://git.kernel.org/pub/scm/git/git.git`
+ `git clone http://www.kernel.org/pub/scm/git/git.git`

## git分支
### 查看分支
+ `git branch`

### 创建分支
+ `git branch name`

### 切换分支
+ `git checkout name`

### 创建+切换分支
+ `git checkout -b name`

### 合并某分支到当前分支
+ `git merge name`

### 删除分支
+ `git branch -d name`

## 其他
### 把当前工作现场“储藏”起来
+ `git stash` //保存现场，恢复之后再用
+ `git stash list`//查看保护现场
  + 恢复现场
    + `git stash apply`//恢复后，stash内容并不删除，你需要用`git stash drop`来删除；
    + `git stash pop`//会删掉stash

## #查看远程库的信息
+ `git remote`
+ `git remote -v`

## 推送分支
+ `git push origin master`
+  如果要推送其他分支，比如dev，就改成 `git push origin dev`

### 指定本地dev分支与远程origin/dev分支的链接
+ `git branch --set-upstream dev origin/dev `
+ `git pull`

## tag 标签
```
//新建标签
git tag v1.0

//给commit id 为25656e2的历史版本打标签
git tag v1.0 25656e2

//查看标签
git tag
```
### 用git show tagname查看标签信息
+ `git show v1.0`

### 推送某个标签到远程
+ `git push origin v1.0`
+ `git push origin --tags`

### 删除标签
分两步，1、删除本地；2、删除远程
+ `git tag -d v0.9`
+ `git push origin :refs/tags/v0.9`

## ignore 文件
不需要从头写.gitignore文件，GitHub已经为我们准备了各种配置文件，只需要组合一下就可以使用了。所有配置文件可以直接在线浏览：https://github.com/github/gitignore

忽略文件的原则是：

1. 忽略操作系统自动生成的文件，比如缩略图等；
2. 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如Java编译产生的.class文件；
3. 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。
