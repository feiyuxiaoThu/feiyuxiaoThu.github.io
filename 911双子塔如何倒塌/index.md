# 911双子塔如何倒塌


> 我导师在911发生时恰好在美国交通部工作，随之参与了事故的一部分调查。同时我导师的博士导师MIT的T. Wierzbicki教授以及余同希教授当时对于这个话题有深入的分析和研究，两位教授后来发表了一篇文章在*International Journal of Impact Engineering*上，后来余老师又翻译其中的一部分内容发表在《力学与实践》上。
> 关于当天还有一个非常有趣的小故事：911当天我导师约了Wierzbicki教授和余同希老师在MIT讨论，结果到了办公室发现Wierzbicki教授居然不在，因为之前从来没有教授的迟到记录，过了半个小时，Wierzbicki教授打电话过来说"Turn on the TV”说他在家里看世贸双子塔的报道，会面延后。结果最后会面上三人一拍即合着力研究高楼的冲击动力学机制，所以才有了后面的两篇论文

这个问题问的非常好，但是首先要强调两点：

1. 题主问“在短时间”的燃烧之后就倒塌了，其实隐含了一个非常有趣的关键信息，双子塔并不是在飞机撞上之后立即倒塌的，一般大家都会认为飞机的撞击载荷是一个非常大的载荷，但是其实不尽然。
2. 对于世贸双子塔而言，其倒塌是逐层倒塌的，而实际上并不是说这个过程是不可抑制的，因为我们都知道在冲击载荷下材料会发生塑性变形是可以耗散能量的，而为什么世贸双子塔的倒塌过程是一个不可逆的过程呢？

关于飞机的撞击本身到底造成了多大影响，可以从力和能量两个方面进行剖析，根据文献中的计算得到的结论：

> The energy absorbed by plastic deformation and fracture of the ill-fated column is only 6.7% of the initial kinetic energy of the wing.

也就是说，当时撞击中大楼所吸收的能量非常的小，只有机翼动能的 *6.7%*

另外，根据估计撞击速度应该为 500km/h,而按照考虑到大量燃油没有使用飞机的重量约为160t，其动能在 ![[公式]](https://www.zhihu.com/equation?tex=1.54+%5Ctimes+10%5E9+J) 。而撞入北楼的飞机在楼宽 ![[公式]](https://www.zhihu.com/equation?tex=s+%3D+63.5m) 的距离中被截停，其平均减速度为 ![[公式]](https://www.zhihu.com/equation?tex=a+%3D+V%5E2%2F2s+%3D+150+m%2Fs%5E2) ，所以平均的撞击力 ![[公式]](https://www.zhihu.com/equation?tex=+2.4+%5Ctimes+10%5E7+N)

尽管这是一个看上去很大的力，但是世贸中心大楼并未被撞倒。这是因为在大楼的设计时考虑到了高达 ![[公式]](https://www.zhihu.com/equation?tex=225km%2Fh) 的风载，可以抵抗的风压达 ![[公式]](https://www.zhihu.com/equation?tex=2kPa) ，所以其总的横向力可以达到 ![[公式]](https://www.zhihu.com/equation?tex=5+%5Ctimes+10%5E7+N) 。

这说明：**飞机撞击的力实际上并没有超过可以承受的最大风力**。

根据后续的多篇研究报告和论文显示，主要的原因是后序**燃油燃烧所产生的高达1100度的高温使得钢铁软化（钢铁一般在425度开始软化，650度会丧失一半强度）**撞机引发的大火首先可以使钢柱与楼层之间的连接件以及钢结构之间的螺栓损毁，继之由于材料的软化和蠕变，许多钢柱都发生屈曲和断裂，致使该层结构逐渐丧失承载能力并坍塌。

下面根据余同希老师的文章，来利用一个非常简单的模型来分析能量转化和耗散过程。

首先，在事故的调查中发现，最初是塔楼上部约20层楼作为一个整体失去支撑而向下坠落，从而使得下部的90层楼逐层被上部的结构砸垮。

![img](https://pic1.zhimg.com/80/v2-ac215541bcf1ccc026d12fe5913409ca_1440w.jpg)



文献中所采用的是这样一个模型，其中 M 为起初坠落体的质量，而m为下部分每一个楼层的质量， h 为楼层的高度。

图中 ![[公式]](https://www.zhihu.com/equation?tex=F_c) 是引起一层结构坍塌的临界载荷。（根据塑性力学，对于钢框架结构而言，当外载到达一定载荷时，结构就会变成一个机构，并且会形成由于弯曲或者屈曲造成的若干集中的塑性区域，也就是塑性铰，使得结构持续变形而不能承受更大的载荷），这一概念可以简单由下面的一个柱子被压溃的典型过程来展示。

![img](https://pic3.zhimg.com/80/v2-34c9d659f8297c9b377a972bee59fca3_1440w.jpg)



当然重要的是在外力在坍塌过程中的做功，下图揭示了载荷力随着轴向位移的变化，我们其实只需要知道**曲线围成的面积代表外力在全过程所做的功，而且其小于矩形面积分** ![[公式]](https://www.zhihu.com/equation?tex=F_ch) ，有

![img](https://pic3.zhimg.com/80/v2-39bccdf407866b34a089c379e577ff3b_1440w.jpg)

![[公式]](https://www.zhihu.com/equation?tex=W_c+%3D+F_ch%2Fw)

其中 ![[公式]](https://www.zhihu.com/equation?tex=w+%3E+1) 是矩形面积和阴影面积之比。

下面可以进行分析。

首先， ![[公式]](https://www.zhihu.com/equation?tex=F_c) 是塔楼第n层的结构临界载荷，而正常情况下其承载能力肯定有安全裕度即 ![[公式]](https://www.zhihu.com/equation?tex=F_c+%3D+s%28110-n%29mg+) ，(110-n)mg 代表n层以上的结构总重量， s 为设计的安全因子。

在临界层（大约是91层）的结构在高温中蠕变失去承载时，顶部约20层的块体下坠，释放出势能，近似使用自由落体计算，其砸到下面一层的速度

![[公式]](https://www.zhihu.com/equation?tex=V+%3D+%5Csqrt%7B2gh%7D+%3D+8.5m%2Fs)

![img](https://pic4.zhimg.com/80/v2-5d32509889e5bd34b1a71aa05de76fc8_1440w.jpg)

于是顶部的块体便和下面一层结合到一起继续撞向更下一层，在更下一层的结构坍塌后，系统动能为

![[公式]](https://www.zhihu.com/equation?tex=E_1+%3D+E_0+%2B+%28M%2B2m%29gh+-+W_c+)
注意 ![[公式]](https://www.zhihu.com/equation?tex=W_c) 为撞击过程中的耗散能量，将

![[公式]](https://www.zhihu.com/equation?tex=F_c+%3D+s%28M%2Bm%29g+)
代入有
![[公式]](https://www.zhihu.com/equation?tex=E_1+-+E_0+%3D+%28M%2Bm%29gh%281-s%2Fw%29+) 这个公式说明了一个重要的结论：

**系统的动能是增加还是减小，取决于 s 和 w 的比值大小**

显然在双子塔的设计中 s<w 使得动能持续增加，从而最后全部垮塌。



参考文献

1. [How the airplane wing cut through the exterior columns of the World Trade Center](https://www.sciencedirect.com/science/article/abs/pii/S0734743X02001069)
2. [世界贸易中心双子楼的动力坍塌浅析](http://www.cnki.com.cn/Article/CJFDTotal-LXYS200202027.htm)


