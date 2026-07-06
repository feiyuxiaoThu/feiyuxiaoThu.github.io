#!/bin/bash
# 一键发布博客文章脚本

if [ -z "$1" ]; then
  echo "❌ 错误: 请提供要发布的 Markdown 文件路径"
  echo "💡 用法: ./publish.sh <文章文件.md>"
  exit 1
fi

FILE="$1"
if [ ! -f "$FILE" ]; then
  echo "❌ 错误: 找不到文件 $FILE"
  exit 1
fi

# 获取文件名和标题
FILENAME=$(basename "$FILE")
TITLE="${FILENAME%.*}"
# 获取当前时间，格式：2026-07-06T19:30:00+08:00
DATE=$(date +"%Y-%m-%dT%H:%M:%S+08:00")
DEST="docs/blogs/posts/$FILENAME"

echo "⏳ 正在处理文章: $TITLE..."

# 生成带有 Front Matter 的新文件
cat << FRONT_MATTER > "$DEST"
---
title: "$TITLE"
date: $DATE
tags:
  - 待分类
categories:
  - 默认分类
description: ""
---

FRONT_MATTER

# 追加原文内容
cat "$FILE" >> "$DEST"
# 如果源文件不在目标目录中，则删除源文件（类似于移动操作）
if [ "$FILE" != "$DEST" ]; then
    rm "$FILE"
fi

echo "✅ 已生成标准格式并移动至: $DEST"
echo "--------------------------------------------------"
echo "如果你需要修改标签 (tags) 或描述 (description)，可以现在打开 $DEST 进行修改。"
read -p "按回车键立即提交并推送发布，或按 Ctrl+C 取消提交操作..."

# 提交并推送
git add "$DEST"
git commit -m "docs: add new blog post $TITLE"
git push

echo "🎉 一键发布完成！GitHub Actions 正在为您构建网站。"
