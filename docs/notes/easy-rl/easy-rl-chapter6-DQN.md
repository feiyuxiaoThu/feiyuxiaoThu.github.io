---
title: easy-rl-chapter6-DQN
tags:
  - RL
  - DQN
date: " 2025-02-26T22:41:44+08:00 "
modify: " 2025-02-26T22:41:44+08:00 "
share: false
cdate: " 2025-02-26 "
mdate: " 2025-02-26 "
math: "true"
---

# 第6章 深度Q网络 结构化总结

## 6.1 状态价值函数

### 核心概念

- **状态价值函数** $V_{\pi}(s)$：表示在策略 $\pi$ 下，从状态 $s$ 开始到游戏结束的期望累积奖励。
- **估计方法**：
  - **蒙特卡洛方法**：通过完整回合的奖励 $G$ 进行回归训练。

    $$

 V_{\pi}(s) \approx G 

$$
  - **时序差分（TD）方法**：利用相邻状态的奖励进行递推更新。
    $$
 V_{\pi}(s_t) = V_{\pi}(s_{t+1}) + r_t 
$$

### 方法对比

| **蒙特卡洛** | **时序差分** |
|--------------|--------------|
| 需完整回合数据 | 仅需单步数据 |
| 方差大（多步奖励叠加） | 方差小（单步奖励） |
| 训练慢（需回合结束） | 训练快（实时更新） |

### 数学推导

时序差分目标：

$$
V_{\pi}(s_t) \leftrightarrow r_t + V_{\pi}(s_{t+1})
$$

训练时最小化均方误差：

$$
\text{Loss} = \left(V_{\pi}(s_t) - (r_t + V_{\pi}(s_{t+1}))\right)^2
$$

---

## 6.2 动作价值函数

### 核心概念

- **Q函数** $Q_{\pi}(s,a)$：在状态 $s$ **强制采取动作 $a$**，后续遵循策略 $\pi$ 的期望累积奖励。
- **策略改进**：通过最大化 Q 值选择动作，生成更优策略 $\pi'$：

$$
  \pi'(s) = \arg\max_a Q_{\pi}(s,a)
$$

---

## 6.3 目标网络

### 设计原理

- **问题**：Q 网络训练时目标值动态变化，导致不稳定。
- **解决方案**：固定目标网络 $\hat{Q}$，周期性同步主网络 $Q$ 的参数。

  ```python
  # 伪代码示例：目标网络更新
  if step % target_update_freq == 0:
      target_network.load_state_dict(q_network.state_dict())
  ```

### 训练流程

1. 主网络 $Q$ 计算当前 Q 值。
2. 目标网络 $\hat{Q}$ 计算目标值：

   $$

 y = r_t + \max_a \hat{Q}(s_{t+1}, a) 

$$
3. 最小化均方误差：$\text{Loss} = (Q(s_t,a_t) - y)^2$

---

## 6.4 探索策略
### 方法对比
| **ε-贪心**                                                                   | **玻尔兹曼探索**                         |
| -------------------------------------------------------------------------- | ---------------------------------- |
| 以概率 $ε$ 随机动作                                                               | 按 Q 值概率分布选择动作                      |
|
$$

 a = \begin{cases} \arg\max Q(s,a) & 1-ε \\ \text{随机} & ε \end{cases} 

$$ |
$$

 \pi(as) \propto e^{Q(s,a)/T} 

$$ |


### 探索必要性
- **维度灾难**：未探索的动作可能导致次优策略固化。
- **平衡探索与利用**：通过动态调整 $ε$ 或温度系数 $T$ 实现。

---

## 6.5 经验回放
### 机制设计
1. **回放缓冲区**：存储历史经验 $(s_t, a_t, r_t, s_{t+1})$。
2. **批量采样**：随机抽取小批量数据训练，打破时序相关性。
3. **优点**：
   - 数据复用，减少环境交互次数。
   - 提升数据多样性，稳定训练。

### 伪代码流程
```python
# 伪代码示例：经验回放
replay_buffer = ReplayBuffer(capacity=50000)
for episode in episodes:
    state = env.reset()
    while not done:
        action = epsilon_greedy(Q, state)
        next_state, reward, done = env.step(action)
        replay_buffer.add(state, action, reward, next_state)
        # 训练阶段
        batch = replay_buffer.sample(batch_size)
        train_q_network(batch)
```

---

## 6.6 深度Q网络算法
### 算法步骤
1. **初始化**：主网络 $Q$ 和目标网络 $\hat{Q}$（参数相同）。
2. **交互收集数据**：使用探索策略（如 ε-贪心）与环境交互。
3. **存储经验**：将数据存入回放缓冲区。
4. **训练网络**：采样批量数据，计算目标值并更新 $Q$。
5. **同步目标网络**：每隔 $C$ 步将 $Q$ 参数复制到 $\hat{Q}$。

### 核心公式
- **目标值计算**：
  $$

 y = r_i + \max_a \hat{Q}(s_{i+1}, a) 

$$
- **损失函数**：
  $$

 \mathcal{L} = \frac{1}{N} \sum_{i} \left(Q(s_i,a_i) - y_i\right)^2 

$$

核心公式
```python
state_batch = torch.tensor(np.array(state_batch), device=self.device, dtype=torch.float)
        action_batch = torch.tensor(action_batch, device=self.device).unsqueeze(1)  
        reward_batch = torch.tensor(reward_batch, device=self.device, dtype=torch.float)  
        next_state_batch = torch.tensor(np.array(next_state_batch), device=self.device, dtype=torch.float)
        done_batch = torch.tensor(np.float32(done_batch), device=self.device)
        q_values = self.policy_net(state_batch).gather(dim=1, index=action_batch) # 计算当前状态(s_t,a)对应的Q(s_t, a)
        next_q_values = self.target_net(next_state_batch).max(1)[0].detach() # 计算下一时刻的状态(s_t_,a)对应的Q值
        # 计算期望的Q值，对于终止状态，此时done_batch[0]=1, 对应的expected_q_value等于reward
        expected_q_values = reward_batch + self.gamma * next_q_values * (1-done_batch)
        loss = nn.MSELoss()(q_values, expected_q_values.unsqueeze(1))  # 计算均方根损失
```

---

## 关键结论
- **DQN核心改进**：价值函数近似 + 目标网络 + 经验回放。
- **异策略特性**：允许使用历史策略数据，提升训练效率。
- **探索与利用平衡**：通过 ε-贪心或玻尔兹曼探索避免局部最优。
