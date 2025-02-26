# 基于信令数据的人口时空分布模型构建


>上学期和一众小伙伴一起完成了一个基于北京市手机信令数据历史分布来进行未来人流分布的模型的构建，在将近一个学期的项目中，在一次次的交流、讨论和修正中学习到了很多，于此进行一个概要的总结。

[项目代码文档](https://github.com/BigDataSystemTHU2018/Project-Unicom)

[项目报告](https://github.com/BigDataSystemTHU2018/Project-Unicom/blob/master/Report.pdf)


## 项目背景


对于城市特别是大型城市而言，预测人口的流动和分布变化对于城市交通治理、公共安全和危险评估都有着重要的战略意义。而由于其受到诸如区域间交通、突发事件、天气等复杂因素的多元影响，利用传统方法对于其进行预测十分困难。

我们将城市分割成均匀网格，基于交通、气象、时间和事件等多源信息，设计了期望输出为驻留人数、出发人数、到达人数有监督人工神经网络，综合预测未来每个网格的人口变化。网络的输入为数据的特征，通过对于数据的预处理和分析我们认为主要需要考虑短周期特性、长周期特性和异常情况的影响三个方面的因素。同时我们以获得数据中的驻留人数作为标签，利用期望输出与网络输出之间的误差建立学习信号反向传播，修正网络权重，最终得到了相对较理想的预测结果。特别是在预测精度方面相对传统方法有着显著的提升，并且对于特定地区的人流异常的预测也表现出了较好的效果。


## 技术路线和技术难点


所主要面临的技术难题有下面几点：

+ 数据结构的转变：如何将手机的信令数据向人口分布和流动数据进行转变，其中的抽样代表性如何保证。
+
缺失值的处理：对于数据中的缺失值如何进行处理，同时也要考虑算法的适用性和对于缺失值的敏感性。
+
额外数据的补充：依据所采取的算法构架，其中所需要得到的额外数据的补充。
算法的预测精度和计算效率的博弈：如何在算法的预测精度得到保证的前提下进行计算速度的提升即算法的优化
+
数据的预分析和预处理: 面对繁杂的原始数据，除了进行一些初步的数据清洗之外，在进入到算法架构的设计和选择之前需要进行数据内在规律的发掘和总结，这样才能较好地得到好的算法设计。

我们分为时间上的周期性，相邻格点的关联性乃至诸如天气变化和节假日等所谓异常时间对于人口分布的影响进行了初步分析，其结果如下图所示：


可以发现：

人流的时间周期明显地分为短周期和长周期等不同周期性的变化，如周内工作日和周末的周期变化，还有不同周之间的周期变化（由于我们拿到的数据的原因，没能体现出我们所推测的季节性的年度周期性变化）
相邻地域的人口动显示出一定的关联性，导致这一问题展现出时空上耦合关联特性。（这也导致初始预分析中所采用的常常用于时间序列分析的ARIMA模型预测效果较差）
节假日和天气等因素也会对人口分布产生影响，从而要加以考量
简而言之，我们所考量的物理量（人口）其影响因素由下面几个方面组成：

$$ \bar{\mu_i} = \mu_i + \psi_{i,w_t} + \theta_{i,h_t} $$

三部分分别代表上面所说的三种因素的影响（当然这里的简单加和可以加以讨论）。

在最初的预分析中，我们首先构建了一个简单的用于时间序列分析的模型（也就是将整个北京的数据分为孤立的格点按照时间序列分析的方法进行分别分析），其结果如下：


可以发现，该方法可以预测趋势但是存在较大误差，其可能原因是源于序列的时间相关性可能是跳跃性的，即某时刻的数据可能与1小时前、2两小时前、24小时前、48小时前、一周前的数据等相关性更高，而不是与之前的数据随时间间隔增大相关性逐渐降低。另外这类模型不能考量其空间相关性，想要考量天气等额外因素更加困难。

## 残差网络人口预测模型构建
### 问题建立

对于人口数据，其直观的显示是如下图中显示的按照地图进行划分，而在我们的模型研究中，将其划分为沿着经纬线划分的M × N矩形网格


### 模型划分

本问题实际上是一个回归分析问题。

### 模型理论基础

模型采用的深度残差网络相比传统的卷积神经网络可以有着更深的结构层数 ，而实践证明其在图像分类、物体识别等问题中有着相当好的应用效果 ，所以我们基于这样的网络结构进行模型的搭建。

一般地，在残差网络中可以将回归预测模型的问题定义为：

$$ X^{l+1} = X^{l} + F(X^{l}) $$

网络的目标就是找到合适的残差函数 $F$ ，下图展示了一个典型的残差单元：


本研究所采用的残差网络的架构，在时间周期层面上考虑小时、天、周三个不同层次的影响，并利用卷积考虑空间上的相互关联，最后再加入外部因素的影响。模型分别采取预测时刻的最近三个小时、一天前的四个小时和一周前的两个小时的数据作为输入，在网络中得到不同的权重，再计算残差实现反向传播。

在实际的网络设计中，考虑到城市不同区域之间的相互关联（如依靠地面公路、地铁的流动）进行卷积核的大小的调整和对于激活函数的定义。

下图是残差网络的示意图：



基于上面的结构图，其中一个需要补充的问题是数据的融合，在实际中，模型中的三个不同时间周期的数据可以用参数矩阵的方法进行混合。

具体的算法见框图：


## 结果分析
将模型的预测结果和下面两种基线结果进行比较：

• 插值方法(naive model)：用历史平均来插值预测，对于某一ID，某一周，某一时刻，计算它的历史平均

• 多层感知机模型(MLP)，即常规的深度神经网络

采用均方残差进行误差评估，即：

下图是结果比较（模型1到4对应不同的残差网络参数）：


绘制为折线图更加直观：


我们可以发现：

模型预测的准确率都显著高于插值预测模型(baseline)，而不同参数之间的预测准确率也会发生改变
不同模型的预测精度均随着预测时间点的后移而下降： 采取逐天分析的方法

更近一步地，考虑到城市的路网和功能区特性，选定特定区域（北京西站和中关村）进行预测结果分析：


可以发现：

预测值和真实值的符合度比较高，误差值在前期的分布没有明显的趋势性， 表 明造成预测误差的一个重要原因可能是随机因素的影响。
对于高峰的预测是相对比较准确的，可以看出本模型可以在诸如火车站、 地铁站等的人流预测和预警中发挥较好的作用。
预测结果与真值的符合程度很高，并且很好的预测出节假日对于人口分布的影响。
## 结果可视化：和地图结合的可视化
应用 Folium 包和 Leaflet 地图进行可视化

## 总结
模型系统性的考虑了人口流动的时空特性，

有着较好的可扩展性：进一步考量节假日等因素

有着较好的可迁移性：模型支持迁移学习，可以在新的应用场景如上海市进行应用

展望：可以考虑进一步考虑对于区域的重新划分

整个项目，虽然从最初地设想来看并没有太大的难点，但是在实际的进行过程中，从和企业的沟通到组内的分工合作，对于问题的分析和重点难点的预计，都少不了深入的调研和思考。总结想来，就如同那句“All models are wrong, but some are useul.”所言，每一次解决问题的尝试和探索，何尝不是对自己如何理解和面对问题的历练，或许这才是我们去学习类似于机器学习等手段的真正意义。


最后还是要感谢一起分析数据，一起写代码，一起调模型的小伙伴们~

### 参考资料和文献
[1] Yu Zheng, Licia Capra, Ouri Wolfson, and Hai Yang. Urban computing: Concepts, methodologies, and applications. ACM Transactions on Intelligent Systems and Technology, 5(3):38, 2014.

[2] Kaiming He, Xiangyu Zhang, Shaoqing Ren, and Jian Sun. Deep residual learning for image recognition. In Proceedings of the IEEE conference on computer vision and pattern recognition, pages 770–778, 2016.

[3] Minh X Hoang, Yu Zheng, and Ambuj K Singh. Fccf: forecasting citywide crowd flows based on big data. advances in geographic information systems, page 6, 2016.

[4] Yang Ye, Yu Zheng, Yukun Chen, Jianhua Feng, and Xing Xie. Mining individual life pattern based on location history. pages 1–10, 2009.

[5] Jiangchuan Zheng and Lionel M Ni. An unsupervised framework for sensing individual and cluster behavior patterns from human mobile data.

[6] Jingbo Shang, Yu Zheng, Wenzhu Tong, Eric Chang, and Yong Yu. Inferring gas consumption and pollution emission of vehicles throughout a city.

[7] Yilun Wang, Yu Zheng, and Yexiang Xue. Travel time estimation of a path using sparse trajectories.

[8] Jing Yuan, Yu Zheng, and Xing Xie. Discovering regions of different functions in a city using human mobility and pois.

[9] Charu C Aggarwal. Data streams: Models and algorithms (advances in database systems).

[10] Wang-Chien Lee, John Krumm, Ke Deng, Kexin Xie, Kevin Zheng, Xiaofang Zhou, Goce Trajcevski, Chi-Yin Chow, Mohemad F. Mokbel, and Hoyoung Je-ung. Computing with spatial trajectories. Computing with Spatial Trajectories.

[11] Atsuyoshi Nakamura and Naoki Abe. Collaborative filtering using weighted majority prediction algorithms.

[12] Tamara G Kolda and Brett W Bader. Tensor decompositions and applications. Siam Review, 51(3):455–500, 2009.

[13] Jerome Friedman, Trevor Hastie, and Robert Tibshirani. The elements of statistical learning, volume 1. Springer series in statistics New York, NY, USA:, 2001.
