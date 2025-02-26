# 如何理解系统的可观测性


系统的可观测性的定义为：

对于系统 ![[公式]](https://www.zhihu.com/equation?tex=%5Cbegin%7Baligned%7D+%5Cdot%7Bx%7D%28t%29+%26%3DA%28t%29+x%28t%29+%5C%5C+y%28t%29+%26%3DC%28t%29+x%28t%29+%5Cend%7Baligned%7D) 在有限的时间区间里 ![[公式]](https://www.zhihu.com/equation?tex=%5Bt_0%2Ct_%7B%5Calpha%7D%5D) 内，对应初态 ![[公式]](https://www.zhihu.com/equation?tex=x%28t_0%29+%3D+%5Cbar%7Bx%7D) ，有


![[公式]](https://www.zhihu.com/equation?tex=y%28t%29+%5Cequiv+0%2C+%5Cquad+t+%5Cin%5Cleft%5Bt_%7B0%7D%2C+t_%7B%5Calpha%7D%5Cright%5D) 则称为不可观测状态，如果不存在这样的不可观测状态，那么系统完全可观测。


这个定义说的非常的抽象，但是可观测性这个概念最重要的是其在 状态观测器(state observer)的设计中发挥了关键作用，下面我就从这个角度进行一些对于状态可观性的介绍。

------

其实，状态可观性的概念是出自于卡尔曼，而著名的Kalman filter也实质上是state estimator for stochastic system[[1\]](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_1)。


对于系统进行控制，首先我们需要确定要进行的控制的类型，一般而言，控制分为基于状态变量的控制和基于输出的控制，这其中最好的当然是状态控制，但是我们往往只有输出和输入，而难以直接得到系统的状态变量，这个时候就需要从前面所说的输出和输入还原出系统的状态变量，这就是所谓的状态观测[[2\]](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_2)。

![img](https://pic4.zhimg.com/80/v2-060801e2b7592a23a3828b7046713790_1440w.jpg)状态反馈和输出反馈

![img](https://pic3.zhimg.com/80/v2-3266d61a72e80409f698d100d13f1805_1440w.jpg)典型状态观测器结构

------

**一言以蔽之，系统状态的可观测性是进行状态观测器设计的前提，也就是说，无论是用什么方法，只有当系统完全可观时，才有可能从状态观测器的设计得出系统的状态的观测。**


以Full-Order Observers为例[[3\]](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_3)，其结构如下:

![img](https://pic3.zhimg.com/80/v2-930737553d9c84c4b6ccccbb681cedc3_1440w.jpg)

对于观测系统有： ![[公式]](https://www.zhihu.com/equation?tex=%5Cdot%7B%5Chat%7Bx%7D%7D+%3D+A+%5Chat%7Bx%7D+%3D+Bu+%5Cquad+%5Chat%7By%7D+%3D++C+%5Chat%7Bx%7D)

跟踪误差为： ![[公式]](https://www.zhihu.com/equation?tex=%5Cwidetilde%7By%7D%3Dy-%5Chat%7By%7D%3DC+x-C+%5Chat%7Bx%7D)

即： ![[公式]](https://www.zhihu.com/equation?tex=%5Cdot%7B%5Chat%7Bx%7D%7D%3DA+%5Chat%7Bx%7D%2BB+u%2BL%28y-%5Chat%7By%7D%29) 和原始系统做差有：

![[公式]](https://www.zhihu.com/equation?tex=%5Cbegin%7Baligned%7D+%5Cdot%7B%5Cboldsymbol%7Bx%7D%7D-%5Cdot%7B%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%7D+%26%3D%5Cboldsymbol%7BA%7D%28%5Cboldsymbol%7Bx%7D-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%29-%5Cboldsymbol%7BL%7D%28%5Cboldsymbol%7By%7D-%5Chat%7B%5Cboldsymbol%7By%7D%7D%29+%5C%5C+%26%3D%5Cboldsymbol%7BA%7D%28%5Cboldsymbol%7Bx%7D-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%29-%5Cboldsymbol%7BL%7D+%5Cboldsymbol%7BC%7D%28%5Cboldsymbol%7Bx%7D-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%29+%5C%5C+%26%3D%28%5Cboldsymbol%7BA%7D-%5Cboldsymbol%7BL%7D+%5Cboldsymbol%7BC%7D%29%28%5Cboldsymbol%7Bx%7D-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%29+%5Cend%7Baligned%7D)

跟踪误差可以求得： ![[公式]](https://www.zhihu.com/equation?tex=%5Cboldsymbol%7Bx%7D%28t%29-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%28t%29%3D%5Cmathrm%7Be%7D%5E%7B%28%5Cboldsymbol%7BA%7D-%5Cboldsymbol%7BL%7D+%5Cboldsymbol%7BC%7D%29%5Cleft%28t-t_%7B0%7D%5Cright%29%7D%5Cleft%5B%5Cboldsymbol%7Bx%7D%5Cleft%28t_%7B0%7D%5Cright%29-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%5Cleft%28t_%7B0%7D%5Cright%29%5Cright%5D)

写成矩阵形式：

![[公式]](https://www.zhihu.com/equation?tex=%5Cleft%5B+%5Cbegin%7Barray%7D%7Bc%7D%7B%5Cdot%7B%5Cboldsymbol%7Bx%7D%7D%7D+%5C%5C+%7B%5Cdot%7B%5Cboldsymbol%7Bx%7D%7D-%5Cdot%7B%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%7D%7D%5Cend%7Barray%7D%5Cright%5D%3D%5Cleft%5B+%5Cbegin%7Barray%7D%7Bcc%7D%7B%5Cboldsymbol%7BA%7D%7D+%26+%7B0%7D+%5C%5C+%7B0%7D+%26+%7B%5Cboldsymbol%7BA%7D-%5Cboldsymbol%7BL+C%7D%7D%5Cend%7Barray%7D%5Cright%5D+%5Cleft%5B+%5Cbegin%7Barray%7D%7Bc%7D%7B%5Cboldsymbol%7Bx%7D%7D+%5C%5C+%7B%5Cboldsymbol%7Bx%7D-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%7D%5Cend%7Barray%7D%5Cright%5D%2B%5Cleft%5B+%5Cbegin%7Barray%7D%7Bl%7D%7B%5Cboldsymbol%7BB%7D%7D+%5C%5C+%7B0%7D%5Cend%7Barray%7D%5Cright%5D+%5Cboldsymbol%7Bu%7D)

我们希望跟踪误差趋近于0并且其衰减速度可以调控，显然这取决于矩阵 ![[公式]](https://www.zhihu.com/equation?tex=A-LC) 的特征根，这就是所谓的极点配置的问题：

- 选择一个合适的 ![[公式]](https://www.zhihu.com/equation?tex=L) ，使得 ![[公式]](https://www.zhihu.com/equation?tex=%5Coperatorname%7BRe%7D%5C%7B%5Clambda%28%5Cboldsymbol%7BA%7D-%5Cboldsymbol%7BL%7D+%5Cboldsymbol%7BC%7D%29%5C%7D%3C0+%5Cquad+%5CLongrightarrow+%5Cquad+%5Clim+_%7Bt+%5Crightarrow+%5Cinfty%7D%5Bx%28t%29-%5Chat%7B%5Cboldsymbol%7Bx%7D%7D%28t%29%5D%3D0)
- 如果 ![[公式]](https://www.zhihu.com/equation?tex=%5Coperatorname%7BRe%7D%5C%7B%5Clambda%28A-L+C%29%5C%7D%3C-%5Csigma) 就可以保证所有的初始值都可以按快于 ![[公式]](https://www.zhihu.com/equation?tex=%5Cmathrm%7Be%7D%5E%7B-%5Csigma+t%7D) 的速度收敛

而根据对偶原理，对于矩阵 ![[公式]](https://www.zhihu.com/equation?tex=A-LC) 的极点配置的问题相当于利用状态反馈 ![[公式]](https://www.zhihu.com/equation?tex=L%5ET) 对于系统 ![[公式]](https://www.zhihu.com/equation?tex=%28A%5ET%2CC%5ET%29) 的极点配置问题，而这等价于系统 ![[公式]](https://www.zhihu.com/equation?tex=%28A%5ET%2CC%5ET%29) 可控，那么即等价于系统 ![[公式]](https://www.zhihu.com/equation?tex=%28A%2CC%29) 可观。这里就解释了可观和可控的对偶的用处以及系统可观性的实际含义。



## 参考

1. [^](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_1_0)段广仁. 线性系统理论. 哈尔滨工业大学出版社, 1996 https://item.jd.com/30834945675.html
2. [^](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_2_0)吴麒主编. 自动控制原理 (第2版, 下册). 清华大学出版社, 2006. http://www.tup.tsinghua.edu.cn/booksCenter/book_02284603.html
3. [^](https://www.zhihu.com/people/feiyuxiaoTHU/answers/by_votes?page=2#ref_3_0)Discrete Control System, Katsuhiko Ogata  https://www.goodreads.com/book/show/241242.Discrete_Time_Control_Systems
