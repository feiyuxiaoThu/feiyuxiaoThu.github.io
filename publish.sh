#!/usr/bin/env bash
# 博客一键发布脚本 (Blog publish helper)
#
# 工作流:
#   1. 把写好的 .md 文章放到仓库根目录的 drafts/ 文件夹
#   2. 本地预览:  ./publish.sh preview [文件.md]
#   3. 发布上线:  ./publish.sh deploy  [文件.md]
#
# 不指定文件时, 会处理 drafts/ 下所有 .md。
set -euo pipefail
cd "$(dirname "$0")"

DRAFTS_DIR="drafts"
POSTS_DIR="docs/blogs/posts"

# 确保文件含有 Front Matter; 缺失则按 "首个 # 标题 / 文件名" 自动生成
ensure_frontmatter() {
  local f="$1"
  [ -f "$f" ] || { echo "❌ 找不到文件: $f"; exit 1; }
  if head -n 1 "$f" | grep -q '^---$'; then
    return 0
  fi
  local title date tmp
  title="$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# *//' | tr -d '\r' || true)"
  [ -z "$title" ] && title="$(basename "${f%.*}")"
  date="$(date +"%Y-%m-%dT%H:%M:%S+08:00")"
  tmp="$(mktemp)"
  {
    printf -- '---\n'
    printf -- 'title: "%s"\n' "$title"
    printf -- 'date: %s\n' "$date"
    printf -- 'tags:\n  - 待分类\n'
    printf -- 'categories:\n  - 默认分类\n'
    printf -- 'description: ""\n'
    printf -- '---\n\n'
    cat "$f"
  } > "$tmp"
  mv "$tmp" "$f"
  echo "📝 已为 $f 生成 Front Matter (title=$title)"
}

# 收集要处理的文件; 未指定文件时取 drafts/ 下所有 .md
collect() {
  if [ -n "${1:-}" ]; then
    [ -f "$1" ] || { echo "❌ 找不到文件: $1" >&2; exit 1; }
    printf '%s\n' "$1"
    return
  fi
  local found=0
  shopt -s nullglob
  for d in "$DRAFTS_DIR"/*.md; do
    [ -e "$d" ] && { printf '%s\n' "$d"; found=1; }
  done
  shopt -u nullglob
  [ "$found" -eq 0 ] && { echo "❌ $DRAFTS_DIR/ 下没有可处理的 .md 文件" >&2; exit 1; }
}

CMD="${1:-}"; shift || true
case "$CMD" in
  preview)
    while IFS= read -r f; do
      ensure_frontmatter "$f"
      cp "$f" "$POSTS_DIR/$(basename "$f")"
      echo "✅ 已放入本地预览: $POSTS_DIR/$(basename "$f")"
    done < <(collect "${1:-}")
    echo "🔍 启动本地预览服务器 http://127.0.0.1:8000 (Ctrl+C 退出)"
    exec uv run mkdocs serve
    ;;
  deploy)
    while IFS= read -r f; do
      name="$(basename "$f")"
      dest="$POSTS_DIR/$name"
      ensure_frontmatter "$f"
      mv "$f" "$dest"
      git add "$dest"
      title="$(grep -m1 '^title:' "$dest" | sed 's/^title:[[:space:]]*//; s/^"//; s/"$//')"
      git commit -m "docs: add blog post $title"
      echo "✅ 已提交: $title"
    done < <(collect "${1:-}")
    git push
    echo "🎉 已推送到 GitHub, Actions 正在构建站点"
    ;;
  *)
    echo "用法:"
    echo "  $0 preview [文件.md]   本地预览 (启动 mkdocs serve)"
    echo "  $0 deploy  [文件.md]   发布到 GitHub (提交并推送)"
    echo "  省略文件时, 处理 $DRAFTS_DIR/ 下所有 .md"
    exit 1
    ;;
esac
