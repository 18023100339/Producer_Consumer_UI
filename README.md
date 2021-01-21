### 模拟仿真“生产者-消费者”问题的解决过程及方法。

### 概要
使用Producer,Consumer两个方法，模拟生产者消费者进程，并通过Controller上的添加生产者按钮、消费者按钮、取消未阻塞的生产者进程按钮、取消未阻塞的消费者进程按钮，来添加或删除生产者进程或消费者进程。同时附加了UICollectionView可视化展示界面，以及清空缓存区资源按钮。


### 使用说明
1、点击添加生产者进程即可添加一个每三秒向缓冲区生产一个产品的进程，该进程在缓冲区满、临界资源被使用等情况下会阻塞
2、点击添加消费者进程即可添加一个每三秒向缓冲区消费一个产品的进程，该进程在缓冲区空、临界资源被使用等情况下会阻塞
3、点击取消未被阻塞的生产者/消费者进程时，可将未被阻塞的进程取消
4、清除所有资源即将缓冲区清空
5、方格图代表了缓冲区，共25格，即缓冲区大小为25，红色代表产品。
