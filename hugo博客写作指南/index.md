# Hugo博客写作指南


自从博客从 Hexo 迁移到 Hugo 之后，购买了个人域名 [xiaofy.top](https://xiaofy.top/)  ，基本上也是经常更新，也逐渐形成了个人博客更新写作的整个工具链。

如果是本地只写作博客的话，我使用 Typora 这样一个跨平台软件进行写作，每次通过新建文章和预览

```go
hugo new posts/post_name.md
hugo server 
```

为了自动化部署写了一个脚本：

```bash
#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
```

比较有用的是使用 PicGo 和 码云 搭建了一个免费的个人图床，访问速度很快，教程可以参考这篇：[PicGo+Gitee搭建个人图床](https://www.cnblogs.com/geq2020/p/12506466.html)

此外，推荐一个平台 [让微信排版变Nice](https://www.mdnice.com/)，当我需要 Blog ，微信公众号一起更新的时候我就会使用这个平台，支持一键复制到微信公众号和知乎，非常非常方便。排版出来的公众号文章也是非常好看，这是我最近排版的一篇文章 [谈谈KMT和九二共识](https://mp.weixin.qq.com/s/V0LSG0LC7F8bqZOEetxZAw)。


