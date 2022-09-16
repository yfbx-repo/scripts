#!/bin/bash
# git 操作
# 

# git 添加tag
function tag-add(){
  git tag -a $1 -m $1
  git push --tags
}

# git 删除tag
function tag-del(){
  git tag -d $1
  git push origin :refs/tags/$1
}

# git 查看远程tag
function tag-remote(){
  git ls-remote --tags
}

# git commit
function cm(){
  git add -A
  git status
  git commit -m $1
}

# git 批量删除本地分支,参数为筛选条件
function branch_del(){
  if [ -z $1 ]; then
    err "command: branch_del <filter>"
    return
  fi
  git branch -a | grep "$1" | xargs git branch -D
}


# 批量删除远程分支,参数为筛选条件
function branch_del_remote(){
   if [ -z $1 ]; then
    err "command: branch_del_remote <filter>"
    return
  fi
  git branch -r | grep  "$1" | sed 's/origin\///g' | xargs -I {} git push origin -d {}
}