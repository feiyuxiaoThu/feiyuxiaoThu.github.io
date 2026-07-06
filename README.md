# Welcome to Tendourisu's Site!

<https://tech.11222022.xyz>

## 本地预览

需要安装 [uv](https://docs.astral.sh/uv/) 和 Python 3.x。

```bash
# 安装依赖
uv pip install -r requirements.txt

# 启动本地开发服务器
uv run mkdocs serve
```

浏览器访问 <http://localhost:8000> 即可预览，修改文件后自动热更新。

## 发布新文章

在 `docs/blogs/posts/` 目录下新增 `.md` 文件，然后提交推送到 `main` 分支：

```bash
git add docs/blogs/posts/你的文章.md
git commit -m "feat: add new post"
git push origin main
```

GitHub Actions 会自动构建并部署到 `gh-pages` 分支，几分钟内网站更新。

## 手动部署

```bash
uv run mkdocs gh-deploy --force
```

这会将站点构建并推送到 `gh-pages` 分支。一般情况下无需手动操作，推送到 `main` 即会自动触发 CI 部署。

## 技术栈

- **框架**: MkDocs
- **主题**: MkDocs Material
- **部署**: GitHub Actions → gh-pages → GitHub Pages
- **域名**: tech.11222022.xyz
