# 博客发布指南 🚀

这是一份为你准备的快速上手指南，帮助你高效地管理和发布文章。

## 1. 创作流程

1.  **新建文件**：在 `docs/blogs/posts/` 目录下创建一个新的 `.md` 文件。
2.  **使用模板**：复制同一目录下的 `POST_TEMPLATE.md` 内容作为起点。
3.  **填写元数据**：
    *   `title`: 文章标题。
    *   `date`: 发布日期（格式：`YYYY-MM-DD`）。
    *   `tags`: 标签列表。

## 2. 本地预览

在根目录下使用 `uv` 运行预览服务器：

```bash
uv run mkdocs serve
```

*   访问 `http://127.0.0.1:8000` 查看效果。
*   **侧边栏会自动更新**，无需手动修改 `mkdocs.yml`。

## 3. 发布到线上

确认无误后，提交并推送代码：

```bash
git add .
git commit -m "feat: 新增文章 <文章标题>"
git push
```

*   GitHub Actions 会自动触发构建。
*   大约 1-2 分钟后，访问 `https://tech.11222022.xyz` 即可看到更新。

## 4. 目录管理 (Awesome Pages)

如果你想调整侧边栏的显示顺序，可以在对应目录下编辑或创建 `.pages` 文件：

```yaml
nav:
  - index.md
  - "特定文章.md"
  - ... # 代表其余所有文件
```

## 5. 图片与附件管理

### 使用外部图床 (推荐)
为了保持仓库精简，建议优先使用你的个人图床：**[pic.11222022.xyz](https://pic.11222022.xyz/)**。

1. 上传图片到图床。
2. 复制 Markdown 链接。
3. 在文章中直接粘贴：`![描述](https://pic.11222022.xyz/xxx.png)`。

### 使用本地图片 (可选)
如果必须使用本地图片：
* 建议存放路径：`overrides/img/`。
* 引用方式：`![描述](../../overrides/img/filename.png)`。

## 6. 一键发布脚本

仓库根目录的 `publish.sh` 可以让"写稿 → 预览 → 发布"一气呵成, 无需手动填 Front Matter 或敲 git 命令。

1. **放稿**：把写好的 `.md` 文章放到仓库根目录的 `drafts/` 文件夹。
   * 有 Front Matter（`---` 开头）会原样保留；没有则脚本按"首个 `# 标题` / 文件名"自动生成 `title`、`date`、`tags` 等。
2. **本地预览**：
   ```bash
   ./publish.sh preview drafts/你的文章.md
   ```
   脚本会把文章放入 `docs/blogs/posts/` 并启动本地服务器 `http://127.0.0.1:8000`, 直接在浏览器查看效果。
3. **发布上线**：
   ```bash
   ./publish.sh deploy drafts/你的文章.md
   ```
   脚本会自动生成/校验 Front Matter、移动到正式目录、提交并推送到 `main`, GitHub Actions 会重新构建站点。

> 省略文件参数时, `preview` / `deploy` 会处理 `drafts/` 下**所有** `.md` 文件。
>
> 侧边栏已经是扁平结构（文章直接挂在 `Blogs` 下, 无 `posts` 子栏目）, 由 `docs/blogs/posts/.pages` 中的 `collapse: true` 控制。
