---
title: cmdb编译部署的正确姿势
date: 2019-8-26 16:09:39
author: 柴米
categories: 项目实战
tags:
  - 项目实战
---
# cmdb编译部署的正确姿势
>写在前面

整个部署从准备到部署成功使用了将近3天的时间，最坑的就是在乔哥那边可以make通过，我这边直接卡在90%，看来还要看脸，emmmm~

我们使用的是源码编译，不使用官方提供的已编译好的版本,这是为什么呢?因为我们要自己做定制化开发，so...,下面就详细记录整个过程。

## 一、工具列表

序号 | 名称|版本|用途说明|下载链接
---|---|---|---|---
1 | VMware Workstation Pro|14|虚拟机管理软件
2| MobaXterm |最新即可|ssh连接软件，也可以使用xshell

## 二、环境列表
序号 | 名称|版本|备注
---|---|---|---
1 | Centos|v7.6X64|http://isoredirect.centos.org/centos/7.6.1810/isos/x86_64/
2| go|v1.12.7|https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
3|python |v>=2.7.5|centos7.6自带python，使用默认即可
4|nodejs|v10.16.0|https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.xz 推荐使用8.x版本
5|ZooKeeper|v3.4|https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz
6|Redis|v3.2|http://download.redis.io/releases/redis-3.2.11.tar.gz
7|MongoDB|v2.8|http://downloads.mongodb.org/linux/mongodb-linux-x86_64-rhel70-2.8.0-rc5.tgz
8|cmdb|v3.2.2|https://github.com/Tencent/bk-cmdb

## 三、工具安装
### 3.1 VMware Workstation Pro14安装
1. 工具安装

安装教程参考 https://blog.csdn.net/qq_31362105/article/details/80706096
2. 虚拟机安装centos

安装教程参考博文 https://blog.csdn.net/xyphf/article/details/82915311

3. 桥接模式配置静态ip

安装后使用ssh连接工具连接。下面是桥接模式配置静态ip的方案：

- a. 首先设置这台linux的网络适配器为桥接模式
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/288FB9D38CF243C798258C412875B72E/11072)


- b. 查看主机网络配置
Ctrl + R 打开运行，输入cmd回车，然后输入ipconfig回车：
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/BFF21BDBCF224BCAA3D57E4065FD0ABF/11080)
记住IPv4地址和默认网关

- c. 虚拟机打开第一个配置文件

```
cd /etc/sysconfig/network-scripts/ 进入网卡配置目录
ll 查看文件信息,因为网卡配置文件名字不同，我这里是ifcfg-eth33
vim ifcfg-eth33编辑文件
```


```
DEVICE=eth0
BOOTPROTO=static #静态IP的关键
HWADDR=00:0C:29:17:01:FC
ONBOOT=yes 启动时加载
TYPE=Ethernet
IPADDR=192.168.1.220  #自己设置静态IP，不冲突就可以
NETMASK=255.255.255.0
GATEWAY=192.168.1.1 #在主机配置中看到的默认网关
BROADCAST=192.168.1.255
DNS1=192.168.1.1 #设置和网关一样的值
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
NM_CONTROLLED=yes
```
- d. 修改网关配置文件

```
vim /etc/sysconfig/network

NETWORKING=yes
NETWORKING_IPV6=no #关掉IPv6
HOSTNAME=localhost.localdomain
GATEWAY=192.168.1.1 #默认网关地址
```
- e. 修改DNS服务器

```
vim /etc/resolv.conf

search localdomain
nameserver 8.8.8.8 #DNS域名解析地址（首选）
nameserver 192.168.1.1 #（备用）可以写成其它比如114.114.114.114
```

- f. 修改完毕之后重启网络服务

```
service network restart
```
ping一下网络看是否配置成功

ping 192.168.10.149 宿主机

ping www.baidu.com

- g. 使用ssh工具连接虚拟机
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/2432E3C5AA2F46759E233DE0052C2376/11115)
填好host、账号、端口使用默认22之后点击ok就可以连接,显示如下图信息表示连接成功。
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/39D860CC302547BC8FD376B28BE50AF1/11217)

## 四、环境安装（基于docker）
> zk、redis、mongoDB可以使用docker快速搭建
### 4.1 安装docker
1、Docker 要求 CentOS 系统的内核版本高于 3.10 ，查看本页面的前提条件来验证你的CentOS 版本是否支持 Docker 。

通过 uname -r 命令查看你当前的内核版本

```
uname -r
```
2、使用 root 权限登录 Centos。确保 yum 包更新到最新

```
sudo yum update
```
3、卸载旧版本(如果安装过旧版本的话)

```
sudo yum remove docker  docker-common docker-selinux docker-engine
```
4、安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

5、设置yum源

```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
![image](https://images2017.cnblogs.com/blog/1107037/201801/1107037-20180128094640209-1433322312.png)

6、更新 yum 缓存

```
sudo yum makecache fast
```
7、查看仓库中所有docker版本，并选择特定版本安装
```
yum list docker-ce --showduplicates | sort -r
```
![image](https://images2017.cnblogs.com/blog/1107037/201801/1107037-20180128095038600-772177322.png)

8、安装docker

```
$ sudo yum install docker-ce  #由于repo中默认只开启stable仓库，故这里安装的是最新稳定版17.12.0
$ sudo yum install <FQPN>  # 例如：sudo yum install docker-ce-17.12.0.ce
```
9、启动并加入开机启动

```
$ sudo systemctl start docker
$ sudo systemctl enable docker
```
10、验证安装是否成功(有client和service两部分表示docker安装启动都成功了)
```
$ docker version
```
### 3.2 Docker安装zookeeper
下载zookeeper镜像
```
docker pull zookeeper
```
启动容器
```
docker run --name my_zookeeper -p 2181:2181 -d zookeeper:latest
```
### 4.2 Docker安装Redis
可以先查看redis镜像的版本
```
root@localhost:~/redis$ docker search  redis
NAME                      DESCRIPTION                   STARS  OFFICIAL  AUTOMATED
redis                     Redis is an open source ...   2321   [OK]       
sameersbn/redis                                         32                   [OK]
torusware/speedus-redis   Always updated official ...   29             [OK]
bitnami/redis             Bitnami Redis Docker Image    22                   [OK]
anapsix/redis             11MB Redis server image ...   6                    [OK]
webhippie/redis           Docker images for redis       4                    [OK]
clue/redis-benchmark      A minimal docker image t...   3                    [OK]
williamyeh/redis          Redis image for Docker        3                    [OK]
unblibraries/redis        Leverages phusion/baseim...   2                    [OK]
greytip/redis             redis 3.0.3                   1                    [OK]
servivum/redis            Redis Docker Image            1                    [OK]
...
```
这里我们拉取官方的镜像,标签为3.2
```
docker pull  redis:3.2
```
docker启动redis并设置密码

```
docker run -d --name myredis -p 6379:6379 redis --requirepass "123456"
```
### 4.3 Docker安装MongoDB并添加用户及数据库

```
docker pull mongo （拉取镜像 默认最新版本）

docker images （查看镜像）

docker run -p 27017:27017 -td mongo （启动镜像）

docker ps （查看启动的镜像）

docker exec -it 镜像id /bin/bash （进入容器）

mongo （进入mongodb）
```
创建用户及数据库：

```
> use admin
switched to db admin
> db.createUser({user:'root',pwd:'Root1q2w',roles:['root']})
Successfully added user: { "user" : "root", "roles" : [ "root" ] }
> db.auth('root','Root1q2w')
1
> use cmdb
switched to db cmdb
> db.createUser({user:"cc",pwd:"cc",roles:[{role:"readWrite",db:"cmdb"}]})
Successfully added user: {
    "user" : "cc",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "cmdb"
        }
    ]
}
> exit
bye
```

### 4.4 安装nodejs
安装环境一般都是源码包安装、mvm方式安装、yum方式安装三种，这里我们选择第一种即源码包安装方式

官网下载centos下载最新版10.9 https://nodejs.org/dist/v10.9.0/node-v10.16.0-linux-x64.tar.xz

```
mkdir /opt/software/ && cd  /opt/software/
tar -xvf node-v10.16.0-linux-x64.tar.xz
mv node-v10.16.0-linux-x64 nodejs
```

建立软连接，变为全局

```
ln -s /opt/software/nodejs/bin/npm /usr/local/bin/ 
ln -s /opt/software/nodejs/bin/node /usr/local/bin/
```


查看安装的版本


```
[root@localhost]# node -v 
v10.16.0
[root@localhost]# npm -v
6.2.0
```


### 4.4 安装go环境
安装包下载地址为：https://golang.org/dl/。

各个系统对应的包名：
![image](https://images2015.cnblogs.com/blog/634508/201704/634508-20170423121505866-1530412422.png)
![image](https://images2015.cnblogs.com/blog/634508/201704/634508-20170423121528257-1993964000.png)


 解压安装

1、下载源码包：go1.7rc3.linux-amd64.tar.gz

2、将下载的源码包解压至 /usr/local目录。

tar -C /usr/local -xzf go1.7rc3.linux-amd64.tar.gz

3、将 /usr/local/go/bin 目录添加至PATH环境变量：

```
vim /etc/profile
export GOROOT=/opt/go #设置为go安装的路径
export GOPATH=/code/goDemo #默认安装包的路径
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
source /etc/profile
```

4、查看版本信息 </p>
 $ go version

5、GOPATH设置 (参考文档：https://studygolang.com/articles/7202)

go命令依赖一个重要的环境变量：$GOPATH 

GOPATH允许多个目录，当有多个目录时，请注意分隔符，多个目录的时候Windows是分号;，Linux系统是冒号: 

当有多个GOPATH时默认将go get获取的包存放在第一个目录下

$GOPATH目录约定有三个子目录
- src存放源代码(比如：.go .c .h .s等)
- pkg编译时生成的中间文件（比如：.a）
- bin编译后生成的可执行文件（为了方便，可以把此目录加入到$PATH变量中，如果有多个gopath，那么使用${GOPATH//://bin:}/bin添加所有的bin目录）

## 五、编译指南
### 5.1源码下载

```
cd $GOPATH/src #首先进入centos配置的GOPATH目录中
git clone https://github.com/Tencent/bk-cmdb  configcenter
```
> 这里注意一下，如果下载的源码文件夹名不叫configcenter，要重命

![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/4CAFC8F18C794AD8BAE882932F9B2953/11429)
上图是我源码目录层级。
在目标机上解压包解**cmdb.tar.gz**，解压后根目录结构如下：

``` shell
-rwxrwxr-x 1 1004 1004 1.2K Mar 29 14:45 upgrade.sh
-rwxrwxr-x 1 1004 1004  312 Mar 29 14:45 stop.sh
-rwxrwxr-x 1 1004 1004  874 Mar 29 14:45 start.sh
-rwxrwxr-x 1 1004 1004  28K Mar 29 14:45 init.py
-rwxrwxr-x 1 1004 1004  235 Mar 29 14:45 init_db.sh
-rwxrwxr-x 1 1004 1004  915 Mar 29 14:45 image.sh
drwxrwxr-x 2 1004 1004 4.0K Mar 31 14:45 web
drwxrwxr-x 2 1004 1004 4.0K Mar 29 14:45 docker
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_adminserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_webserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_apiserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_toposerver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_procserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_hostserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_eventserver
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_datacollection
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_proccontroller
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_objectcontroller
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_auditcontroller
drwxrwxr-x 3 1004 1004 4.0K Mar 29 14:45 cmdb_hostcontroller
```

各目录代表的服务及职责：

|目标|类型|用途描述|
|---|---|---|
|upgrade.sh|script|用于全量升级服务进程|
|stop.sh|script|用于停止所有服务|
|start.sh|script|用于启动所有服务|
|init.py|script|用于初始化服务及配置项，在需要重置服务配置的时候也可以运行此脚本，按照提示输入配置参数|
|init_db.sh|script|初始化数据库的数据|
|image.sh|script|用于制作Docker镜像|
|web|ui|CMDB UI 页面|
|docker|Dockerfile|各服务的Dockerfile模板|
|cmdb_adminserver|server|负责系统数据的初始化以及配置管理工作|
|cmdb_webserver|server|web server 服务子目录|
|cmdb_apiserver|server|场景层服务，api 服务|
|cmdb_toposerver|server|场景层服务，负责模型的定义以及主机、业务、模块及进程等实例数据的维护|
|cmdb_procserver|server|场景层服务，负责进程数据的维护|
|cmdb_hostserver|server|场景层服务，主机数据维护|
|cmdb_eventserver|server|场景层服务，事件推送服务|
|cmdb_datacollection|server|场景层服务，数据采集服务|
|cmdb_proccontroller|controller|进程资源数据维护基础接口|
|cmdb_objectcontroller|controller|模型数据维护接口|
|cmdb_auditcontroller|controller|审计数据维护服务|
|cmdb_hostcontroller|controller|主机数据维护服务|
### 5.2进入源码根目录

```
cd $GOPATH/src/configcenter/src
```
编译共有以下三种模式，第一次编译我们选择make即同时编译前端UI和后端服务
```
#同时编译前端UI和后端服务
make
#仅编译后端服务
make server
#仅编译前端UI
make ui
```
### 5.3打包
编译好之后我们再进行打包
```
make package
```
归档包存放位置： $GOPATH/src/configcenter/src/bin/pub/cmdb.tar.gz

## 六、启动cmdb
### 6.1进入归档包目录

```
cd $GOPATH/src/configcenter/src/bin/pub/cmdb
```
### 6.2生成配置脚本，注意需要换成自己IP地址

```
python init.py --discovery 192.168.10.222:2181 --database cmdb --redis_ip 192.168.10.222 --redis_port 6379 --redis_pass Root1q2w --mongo_ip 192.168.10.222 --mongo_port 27017 --mongo_user cc --mongo_pass cc --blueking_cmdb_url http://192.168.10.222:8083 --listen_port 8083
```

```
#返回信息如下
rd_server:192.168.10.222:2181
database: cmdb
redis_ip:192.168.10.222
redis_port: 6379
redis_pass: Root1q2w
mongo_ip: 192.168.10.222
mongo_port: 27017
mongo_user: cc
mongo_pass: cc
blueking_cmdb_url: http://192.168.10.222:8083
listen_port: 8083
initial configurations success, configs could be found at cmdb_adminserver/configures
```
### 6.3启动并初始化数据库

```
./start.sh

starting: cmdb_adminserver
starting: cmdb_apiserver
starting: cmdb_auditcontroller
starting: cmdb_datacollection
starting: cmdb_eventserver
starting: cmdb_hostcontroller
starting: cmdb_hostserver
starting: cmdb_objectcontroller
starting: cmdb_proccontroller
starting: cmdb_procserver
starting: cmdb_toposerver
starting: cmdb_webserver
root      14481      1  5 07:10 pts/1    00:00:00 ./cmdb_adminserver --addrport=192.168.10.222:60004 --logtostderr=false --log-dir=./logs --v=3 --config=configures/migrate.conf
root      14496      1  1 07:10 pts/1    00:00:00 ./cmdb_apiserver --addrport=192.168.10.222:8080 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14512      1  1 07:10 pts/1    00:00:00 ./cmdb_auditcontroller --addrport=192.168.10.222:50005 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14527      1  1 07:10 pts/1    00:00:00 ./cmdb_datacollection --addrport=192.168.10.222:60005 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14547      1  1 07:10 pts/1    00:00:00 ./cmdb_eventserver --addrport=192.168.10.222:60009 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14570      1  1 07:10 pts/1    00:00:00 ./cmdb_hostcontroller --addrport=192.168.10.222:50002 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14588      1  0 07:10 pts/1    00:00:00 ./cmdb_hostserver --addrport=192.168.10.222:60001 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14606      1  0 07:10 pts/1    00:00:00 ./cmdb_objectcontroller --addrport=192.168.10.222:50001 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14623      1  0 07:10 pts/1    00:00:00 ./cmdb_proccontroller --addrport=192.168.10.222:50003 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14641      1  0 07:10 pts/1    00:00:00 ./cmdb_procserver --addrport=192.168.10.222:60003 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14660      1  0 07:10 pts/1    00:00:00 ./cmdb_toposerver --addrport=192.168.10.222:60002 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=192.168.10.222:2181
root      14677      1  0 07:10 pts/1    00:00:00 ./cmdb_webserver --addrport=192.168.10.222:8083 --logtostderr=false --log-dir=./logs --v=3 --regdiscv=127.0.0.1:2181
process count should be: 12 , now: 12
```
稍等几分钟，执行如下命令返回数量为12条即没问题

```
ps aux|grep cmdb|wc -l
```


数据库在第一次部署的时候初始化就行，以后更改源码及编译，不需要初始化
```
bash ./init_db.sh
```
检查所有服务是否全部启动
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/F0F43E6CF148497681709341BC701798/11490)

访问192.168.10.222:8083
![image](https://note.youdao.com/yws/public/resource/e7a22c616f349c8fc6634454391d8995/xmlnote/A5A63D4424CC4A109855AB9E68B93DC5/11504)

## Last but not least
> 在每一次启动一个服务的时候，要检测是否启动成功，可以用ps -ef|grep xxx或者其他进程或端口命令来检测。

文档有不足或者错误的地方，请评论或者联系邮箱:ning.chai@foxmail.com哦。