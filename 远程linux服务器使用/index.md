# 远程Linux服务器使用


最近要开始做一个关于 NLP 的项目 [Github Organization](https://github.com/BigDataPractice2020)，项目方给我们提供了服务器远程访问，仔细想来也是我第一次真正完全使用无界面的 Linux (WSL也算？之前用的比较多的还是 Ubuntu 装在虚拟机里面)，记录一些有趣的点。

访问是挂了 VPN 之后使用 Xshell ssh 方式访问，我进去一看是个空服务器，于是我先配置了 Anaconda 和 Pytorch ，Anaconda 装倒是没啥问题，倒是现在 Pip 都要使用 --user 选项。

## 配置 Vscode remote

![](https://img-blog.csdnimg.cn/20191128143221179.png) 

主要参考 [用VSCode的Remote-SSH连接Linux进行远程开发](https://www.cnblogs.com/WindSun/p/12142621.html) 一文，后来发现我们没有 root 权限，就暂且搁置了和那边沟通让他们先试一试。我倒是顺便试了一试连电脑上的 WSL 和 Ubuntu 的虚拟机，感觉 Vscode 的 这个 Remote 插件确实是很好用，准备回头在 WSL 里面把 Texlive 2020 配置一下。

还有一点就是可以很方便的使用 WinSCP 在服务器和本地主机之间共享文件，还支持远程编辑，使得没有 Root 权限的我们使用就更加便利。

## 安装 Pytorch

首先我发现 Cuda 是装好的（不然我基本上装不了 Pytorch），装 Pytorch 最大的坑就是版本的问题，我这个 Cuda 是10.0，在国内的阿里源还是科大源都找不到对应的，还是最后使用默认的源下载了，幸好速度还不错。

## 接下来计划

有一个比较好的习惯是在 Conda 创建一个虚拟环境，然后在里面配置框架做自己的事情：

```bash
conda create -n xx python = 3.x # 创建xx虚拟环境
conda activate xx # 激活
conda deactivate # 关闭
```

接下来几天就准备跑一跑小型的 Bert 模型的 case ，然后学习下 Bert 框架的代码和其应用的方法。
