---
title: easy-rl-chapter9-演员-评论员算法总结
tags:
  - RL
date: " 2025-03-04T19:31:14+08:00"
modify: " 2025-03-04T19:31:14+08:00 "
share: false
cdate: " 2025-03-04 "
mdate: " 2025-03-04 "
math: "true"
---

# 第9章 演员-评论员算法总结

## 9.1 基本概念与背景

### 演员-评论员算法简介

- **演员-评论员算法**是结合**策略梯度**和**时序差分学习**的强化学习方法
- **演员(Actor)**：策略函数 $\pi_{\theta}(a|s)$，学习策略以获得高回报
- **评论员(Critic)**：价值函数 $V_{\pi}(s)$，评估当前策略的值函数
- **优势**：单步参数更新，不需要等到回合结束才更新

### REINFORCE算法的局限性

- 需要采集完整轨迹才能计算回报
- 采样方差大，学习效率低

## 9.2 策略梯度回顾

### 策略梯度基本公式

$$
  \nabla \bar{R}_{\theta} \approx \frac{1}{N} \sum_{n=1}^{N} \sum_{t=1}^{T_{n}}\left(\sum_{t^{\prime}=t}^{T_{n}} \gamma^{t^{\prime}-t} r_{t^{\prime}}^{n}-b\right) \nabla \log p_{\theta}\left(a_{t}^{n} \mid s_{t}^{n}\right) \tag{9.1}
$$

### 公式解释

- $p_{\theta}(a_t|s_t)$：在状态$s$采取动作$a$的概率
- $\sum_{t^{\prime}=t}^{T_{n}} \gamma^{t^{\prime}-t} r_{t^{\prime}}^{n}$：折扣累积奖励
- $b$：基线值，使括号内项有正有负
- $G$：累积奖励，是一个随机变量，方差较大

### 策略梯度的问题

- 采样的累积奖励$G$方差大，训练不稳定
- 每次采样次数有限，容易受样本差异影响

## 9.3 深度Q网络回顾

### 两种评论员函数

1. **状态值函数** $V_{\pi}(s)$
   - 输入状态$s$，输出在策略$\pi$下的期望累积奖励
   - 不涉及具体动作

2. **状态-动作值函数** $Q_{\pi}(s,a)$
   - 输入状态$s$和动作$a$，输出在策略$\pi$下的期望累积奖励
   - 考虑具体动作的价值

### 期望值替代采样值

- 用网络估测$G$的期望值，即$Q_{\pi}(s,a)$
- 使用期望值代替采样值可以使训练更加稳定

## 9.4 优势演员-评论员算法(A2C)

### 优势函数定义

- 优势函数：$A^{\theta}(s, a) = Q_{\pi_{\theta}}(s, a) - V_{\pi_{\theta}}(s)$
- 表示采取动作$a$相对于平均水平的优势

### 简化计算方法

- 将$Q_{\pi}(s_t^n, a_t^n)$近似为$r_t^n + V_{\pi}(s_{t+1}^n)$
- 只需要估计$V$网络，不需要估计$Q$网络
- 优势函数变为：$r_t^n + V_{\pi}(s_{t+1}^n) - V_{\pi}(s_t^n)$

### 优势演员-评论员算法的梯度公式

$$
  \nabla \bar{R}_{\theta} \approx \frac{1}{N} \sum_{n=1}^{N} \sum_{t=1}^{T_{n}}\left(r_{t}^{n}+V_{\pi}\left(s_{t+1}^{n}\right)-V_{\pi}\left(s_{t}^{n}\right)\right) \nabla \log p_{\theta}\left(a_{t}^{n} \mid s_{t}^{n}\right) \tag{9.2}
$$

### 算法流程

1. 演员与环境交互收集数据
2. 使用收集的数据估计价值函数
3. 基于价值函数更新策略(演员)
4. 使用新策略重复上述过程

### 实现技巧

1. **网络架构**
   - 演员网络和评论员网络可以共享前几层
   - 对图像输入，前面的卷积层可以共用参数

2. **探索机制**
   - 对策略分布设置熵的约束
   - 让不同动作被采用的概率相对平均，增加探索

## 9.5 异步优势演员-评论员算法(A3C)

### A3C的基本思想

- 同时使用多个进程(worker)与环境交互
- 每个进程独立收集经验，加速训练

### A3C工作流程

1. 全局网络包含策略网络和价值网络
2. 多个进程各自复制全局网络参数
3. 每个进程与环境交互，收集不同样本
4. 计算梯度后更新全局网络参数
5. 进程不会互相等待，异步更新

### A3C的优势

- 平行探索提高采样效率
- 样本多样性增强，减少过拟合

## 9.6 路径衍生策略梯度(DDPG)

### DDPG的核心思想

- 可看作解决连续动作空间的DQN方法
- 也可视为特殊的演员-评论员方法
- 评论员不仅告诉动作好坏，还直接指导演员采取什么动作

### DDPG与DQN的关系

- 解决DQN在连续动作空间中难以找到最优动作的问题
- 用演员网络解决argmax优化问题

### DDPG算法步骤

1. 演员与环境交互并估计Q值
2. 固定Q网络，学习演员网络
3. 演员网络目标是最大化Q值输出
4. 用新演员与环境交互，更新Q网络

### 从DQN到DDPG的四个改变

1. 用演员网络$\theta$决定动作，替代Q网络
2. 用策略替代原来的argmax操作
3. 增加学习演员网络$\theta$的目标：最大化Q函数输出
4. 不仅有目标Q网络，还有目标策略网络

## 9.7 与生成对抗网络(GAN)的联系

### GAN与演员-评论员的相似性

- GAN中生成器类似于演员
- GAN中判别器类似于评论员
- 两者训练难度相似

### 技术交叉应用

- GAN的训练技巧可应用于演员-评论员
- 演员-评论员的方法可用于改进GAN

### 联系表格

|       | GAN          | 演员-评论员      |
| ----- | ------------ | ---------------- |
| 目标  | 生成真实样本 | 寻找最优策略     |
| 主体1 | 生成器       | 演员(Actor)      |
| 主体2 | 判别器       | 评论员(Critic)   |
| 难点  | 训练稳定性   | 采样效率与稳定性 |

## 关键概念总结

1. **演员-评论员结构**：结合策略学习(演员)和值函数估计(评论员)的双网络结构
2. **优势函数**：$A(s,a) = Q(s,a) - V(s)$，衡量动作相对于平均水平的好坏
3. **单步TD更新**：不需等到回合结束，利用TD误差进行单步更新
4. **网络共享**：演员网络和评论员网络共享前几层参数
5. **异步更新**：多进程同时收集经验并异步更新参数(A3C)
6. **连续动作空间**：DDPG通过演员网络解决连续动作空间中的动作选择问题

找到具有 1 个许可证类型的类似代码

# 演员-评论员算法总结

## 1. 基本概念与背景

### 演员-评论员算法的基本思想

- **演员-评论员算法**结合了**策略梯度**和**时序差分学习**
- **演员 (Actor)**：策略函数 $\pi_{\theta}(a|s)$ ，学习策略以获得高回报
- **评论员 (Critic)**：价值函数 $V_{\pi}(s)$ ，评估当前策略的价值
- **核心优势**：可以进行单步参数更新，不需等到回合结束

### REINFORCE 算法的局限

- 需要采集完整轨迹计算回报
- 采样方差大，学习效率低

## 2. 策略梯度回顾

### 基本梯度公式

$$
\nabla \bar{R}_{\theta} \approx \frac{1}{N} \sum_{n=1}^{N} \sum_{t=1}^{T_{n}}\left(\sum_{t^{\prime}=t}^{T_{n}} \gamma^{t^{\prime}-t} r_{t^{\prime}}^{n}-b\right) \nabla \log p_{\theta}\left(a_{t}^{n} \mid s_{t}^{n}\right)
$$

### 累积奖励的问题

- 累积奖励 $G$ 是随机变量，方差大
- 采样数量有限导致训练不稳定
- 同一状态-动作对可能得到截然不同的结果

## 3. 深度 Q 网络回顾

### 两种价值函数

1. **状态值函数** $V_{\pi}(s)$
   - 表示在状态 $s$ 下按策略 $\pi$ 行动的期望累积奖励
   - 输入为状态，输出为标量

2. **状态-动作值函数** $Q_{\pi}(s,a)$
   - 表示在状态 $s$ 下执行动作 $a$ 后按策略 $\pi$ 行动的期望累积奖励
   - 输入为状态-动作对

## 4. 优势演员-评论员算法

### 优势函数

- $G$ 的期望值就是 Q 值： $\mathbb{E}[G_t^n]=Q_{\pi_\theta}(s_t^n,a_t^n)$
- 优势函数定义： $A^{\theta}(s_t^n,a_t^n)=Q_{\pi_{\theta}}(s_{t}^{n}, a_{t}^{n})-V_{\pi_{\theta}}(s_{t}^{n})$
- $V_{\pi_{\theta}}(s_t^n)$ 作为基线，使得优势函数有正有负

### 优势函数的简化

- $Q_{\pi}(s_{t}^{n}, a_{t}^{n})=\mathbb{E}[r_{t}^{n}+V_{\pi}(s_{t+1}^{n})]$ （定义）
- 简化为： $Q_{\pi}(s_{t}^{n}, a_{t}^{n})=r_{t}^{n}+V_{\pi}(s_{t+1}^{n})$ （移除期望）
- 优势函数变为： $A^{\theta}(s_t^n,a_t^n)=r_{t}^{n}+V_{\pi}(s_{t+1}^{n})-V_{\pi}(s_{t}^{n})$

### 修改后的策略梯度

$$
\nabla \bar{R}_{\theta} \approx \frac{1}{N} \sum_{n=1}^{N} \sum_{t=1}^{T_{n}}(r_{t}^{n}+V_{\pi}(s_{t+1}^{n})-V_{\pi}(s_{t}^{n}))\nabla \log p_{\theta}(a_{t}^{n} \mid s_{t}^{n})
$$

### 算法流程

1. 演员与环境交互收集数据
2. 用收集数据估计价值函数（评论员）
3. 基于价值函数更新策略（演员）
4. 用新策略与环境交互，循环往复

### 实现技巧

1. **网络架构**：演员网络和评论员网络可共享前几层
2. **探索机制**：对策略分布设置熵约束，使动作分布更平均

## 5. 异步优势演员-评论员算法 (A3C)

### 核心思想

- 利用多进程同时与环境交互，加速训练
- 类似"影分身"同时积累多个经验

### 工作流程

1. 维护一个全局网络（包含策略和价值网络）
2. 多个进程复制全局参数，独立与环境交互
3. 每个进程计算梯度后更新全局网络
4. 异步更新模式：各进程独立工作，不互相等待

### 优点

- 加速训练速度
- 增加样本多样性
- 减少过拟合风险

## 6. 路径衍生策略梯度 (DDPG)

### 基本思想

- 可视为解决连续动作空间的 DQN 方法
- 评论员不仅评价动作好坏，还指导演员选择动作

### 算法步骤

$$
\pi^{\prime}(s)=\underset{a}{\arg \max} Q_{\pi}(s, a)
$$

1. 固定 Q 网络，学习演员网络最大化 Q 值输出
2. 演员网络解决了连续动作空间中 argmax 难以计算的问题

### 从 DQN 到 DDPG 的改变

1. 用演员网络决定动作，替代 Q 函数
2. 策略替代 argmax 操作
3. 学习演员网络最大化 Q 函数
4. 增加目标策略网络和目标 Q 网络

## 7. 与生成对抗网络 (GAN) 的联系

### 相似性

- GAN 生成器 ≈ 演员
- GAN 判别器 ≈ 评论员
- 两者训练方式相似

### 技术交叉

- GAN 训练技巧可应用于演员-评论员算法
- 演员-评论员方法可用于改进 GAN

### 比较

| 方面     | GAN              | 演员-评论员        |
| -------- | ---------------- | ------------------ |
| 目标     | 生成逼真样本     | 寻找最优策略       |
| 主角 1   | 生成器           | 演员               |
| 主角 2   | 判别器           | 评论员             |
| 优化目标 | 最小化 JS 散度   | 最大化期望回报     |
| 训练挑战 | 模式崩溃、稳定性 | 样本效率、梯度估计 |

## 关键算法比较

| 算法      | 特点                | 优势                 | 劣势               |
| --------- | ------------------- | -------------------- | ------------------ |
| REINFORCE | 基础策略梯度        | 直接最大化回报       | 方差大，效率低     |
| A2C       | 优势演员-评论员     | 单步更新，方差降低   | 需同时学习两个网络 |
| A3C       | 异步优势演员-评论员 | 多进程并行，加速训练 | 需要多核 CPU       |
| DDPG      | 路径衍生策略梯度    | 解决连续动作问题     | 训练不稳定         |

## 实现要点总结

- **两个网络**：同时学习演员 (策略) 和评论员 (价值)
- **共享参数**：两网络前几层可共享参数，尤其是处理图像输入时
- **优势函数**：使用 $r_t + V(s_{t+1}) - V(s_t)$ 作为优势估计
- **探索策略**：保持策略熵不要太小，鼓励探索
- **异步更新**：可利用多进程加速训练 (A3C)
