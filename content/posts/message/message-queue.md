+++
title = "消息队列（一）"
date = "2019-07-10"
lastmod = "2019-07-10"
tags = [
    "消息队列",
    "RabbitMQ"
]
categories = [
    "技术"
]
+++

本部分内容为学习消息队列所做的笔记。

<!--more-->

### 为什么使用消息队列？

使用消息队列有如下好处：

* 异步：服务器端组件接到用户请求之后，即可快速响应用户，大大提高了接口的性能。
* 解耦：可以解耦后台组件，后台不同服务按需订阅和消费消息，系统耦合性大大降低。
* 削峰填谷：可以借助于消息中间件缓冲和摊平并发量高峰期的请求。


### 使用消息队列有什么优缺点？

使用了消息中间件后，会带来如下问题：
* 系统可用性降低，整个系统的数据传输依赖于消息中间件，如果消息中间件挂宕，系统将无法使用。
* 系统复杂性提高，加入消息中间件后，需要考虑消息重复消费、消息丢失及消息顺序性等问题，系统复杂性提高了。
* 会带来数据一致性问题，消息在系统中各服务之间传递时，可能会不一致。


### 怎么保证消息不丢失？
使用消息队列的时候，需要考虑消息丢失的问题，以 RabbitMQ 为例来说明下。

#### 生产者丢失数据

RabbitMQ 生产者将数据发送到 RabbitMQ 的时候，可能数据在网络传输中丢失了，此时 RabbitMQ 接收不到数据，消息就丢失了。

RabbitMQ 提供了两种方式来解决此问题：
* 事务方式
在生产者发送消息之前，通过 `channel.txSelect` 开启一个事务，接着发送消息。如果消息没有成功被 RabbitMQ 接收到，生产者会收到异常，此时，就可以进行事务回滚 `channel.txRollback`，然后重新发送。
如果 RabbitMQ 收到了这个消息，就可以通过 `channel.txCommit` 提交事务。但此时生产者的吞吐量和性能都会降低很多，现在一般不这样做。

* Confirm 机制
在生产者这边设置 Confirm 模式，就是每次发送消息的时候会分配一个唯一的 ID，然后 RabbitMQ 收到之后会回传一个 ACK，告诉生产者，这个消息接收到了；
如果 RabbitMQ 没有接收到这个消息，则回调一个 Nack 的接口，这个时候生产者就可以重新发送该消息。

事务机制和 Confirm 机制最大的不同在于事务机制是同步的，提交一个事务之前会阻塞在那里；而 Confirm 机制是异步的，发送一个消息之后就可以发送下一个消息，然后那个消息 RabbitMQ 接收了之后会异步回调一个接口，通知生产者这个消息接收到了。

因此，一般在生产者端避免数据丢失，都是使用 Confirm 机制。

#### RabbitMQ 丢失数据
RabbitMQ 集群也会丢失消息，在消息发送到 RabbitMQ 之后，默认是没有落地磁盘的，如果 RabbitMQ 服务进程死掉，此时消息就丢失了。

为了解决这个问题，RabbitMQ 提供了一个持久化机制，消息写入之后会持久化到磁盘。这样即使是服务挂掉，恢复之后也会自动恢复之前存储的数据，这样的机制可以确保消息不会丢失。

设置持久化有两个步骤：
* 创建队列的时候，将其设置为持久化的，这样就可以保证 RabbitMQ 持久化队列的元数据，但是不会持久化队列里的数据。
* 发送消息的时候将消息的 deliveryMode 设置为 2，就是将消息设置为持久化的，此时 RabbitMQ 就会将消息持久化到磁盘上去。

如果消息发送到 RabbitMQ 之后，还没来得及持久化到磁盘，RabbitMQ 就挂掉了，数据也就丢失了，怎么处理？

对于这个问题，其实是配合上面的 Confirm 机制一起来保证的，就是在消息持久化到磁盘之后才会给生产者发送 ACK 消息。如果真的遇到了那种极端情况，生产者是可以感知到的，此时生产者可以通过重试发送消息给别的 RabbitMQ`节点。

#### 消费者丢失数据
在 RabbitMQ 消费者消费消息的时候，刚拿到消息，RabbitMQ 进程挂掉了，这个时候 RabbitMQ 就会认为消费者已经消费成功了，这条数据就丢失了。

对于这个问题，要先说明一下 RabbitMQ 消费消息的机制：在消费者收到消息的时候，会发送一个 ACK 给 RabbitMQ，告诉 RabbitMQ 这条消息被消费到了，这样 RabbitMQ 就会把这条消息删除。
但是默认情况下，这个发送 ACK 的操作是自动提交的，也就是说消费者一收到这个消息，就会自动返回 ACK 给 RabbitMQ，所以会出现消息丢失的问题。

因此，针对这个问题的解决方法就是：关闭 RabbitMQ 消费者的自动提交 ACK，在消费者处理完这条消息之后再手动提交 ACK。这样即使遇到了上面的情况，RabbitMQ 也不会把这条消息删除，会在程序重启之后，重新下发这条消息过来。


### 怎么保证消息中间件的高可用性？

使用了消息队列之后，我们希望消息队列服务高可用，不能因为机器宕机了，就出现无法收发消息的情况。

RabbitMQ 有三种模式：
* 单机模式
* 普通集群模式
* 镜像集群模式

1）单机模式

单机模式就是在一台机器上部署了一个 RabbitMQ 程序，存在单点问题，可用于测试使用，生产环境不能使用。

2）普通集群模式

普通集群模式是在多台机器上启动多个 RabbitMQ 实例，类似于 Master-Slave 模式。但是创建的队列只会放在一个 Master RabbitMQ 实例上，其他实例都同步那个接收消息的 RabbitMQ 元数据。

在消费消息的时候，如果连接到的 RabbitMQ 实例不是存放队列数据的实例，这个时候 RabbitMQ 就会从存放队列数据的实例上拉取数据，然后返回给客户端。
这种方式有点麻烦，没有做到真正的分布式，每次消费者连接一个实例后拉取数据，如果连接到的不是存放队列数据的实例，这个时候会造成额外的性能开销。如果从放队列的实例拉取，会导致单实例性能瓶颈。
如果放队列数据的 RabbitMQ 实例进程挂掉了，会导致其他实例无法拉取数据，这个集群也就无法消费消息了，没有做到真正的高可用。这个方案主要是提高系统的吞吐量，就是说让集群中的多个节点来服务于某个队列的读写操作。

3）镜像集群模式

镜像集群模式是真正的 RabbitMQ 高可用模式，创建的队列无论是元数据还是队列里的消息都会存在于多个实例上。每次写消息到队列的时候，都会自动把消息同步到多个实例的队列中。

这样的话，任何一个机器宕机了，别的实例都可以用来提供服务，真正做到了高可用。

但是也存在着不足之处：
* 性能开销过高，消息需要同步至所有机器，会导致网络带宽压力和消耗很大。
* 扩展性低：无法解决某个队列数据量特别大的情况，导致队列无法线性扩展，就算加了机器，那个机器也会包含队列的所有数据，队列的数据没有做到分布式存储。

对于 RabbitMQ 的高可用一般的做法都是开启镜像集群模式，这样最起码做到了高可用，一个节点宕机了，其他节点可以继续提供服务。

### 参考资料

https://mp.weixin.qq.com/s/gqFVeZIE6nfYQd57pQkfaA
