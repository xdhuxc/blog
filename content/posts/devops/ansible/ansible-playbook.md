+++
title = "Ansible 学习之简单入门"
linktitle = "Ansible 学习之简单入门"
date = "2018-05-14"
lastmod = "2018-05-14"
description = ""
tags = [
    "Ansible",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了 Ansible Playbook 的使用方法。

<!--more-->

### Ansible Playbook
ansible playbook 是一系列 ansible 命令的集合，使用 yaml 语言编写，playbook 命令根据自上而下的顺序依次执行。Ansible 可以完成一组复杂的动作，例如部署环境、搭建服务、修改配置等。Ansible 可以允许传输某个命令的状态到后面的指令，例如，我们可以从一台机器的文件中抓取内容并赋为变量，然后在另外一台机器中使用，这使得我们可以实现一些复杂的部署机制，这是 ansible 命令所无法实现的。

ansible-playbook 的简单使用方法：
```markdown
ansible-playbook ./xdhuxc-play.yaml # 执行 xdhuxc-play.yaml 文件
```

#### 简单示例

下面是一个简单的 ansible-playbook 的示例：
```markdown
- name: create user
    hosts: all
    user: root
    gather_facts: false
    vars:
      user: "xdhuxc"
    tasks:
      - name: create user
          user: name="{{user}}"
```
以上 playbook 实现的功能是：新增一个用户

说明如下：

* name：对该 playbook 实现的功能做一个描述，后面执行过程中，会打印 name 变量的值；
* hosts：指定了要进行操作的主机。
* user：指定了登录远程主机操作的用户。
* gather_facts：指定了在以下任务部分执行前，是否先执行 setup 模块获取主机相关信息。
* vars：指定变量。这里指定一个变量 user，其值为 xdhuxc，需要注意，变量值一定要使用双引号引住。
* task：指定了一个任务，其下面的 name 参数同样是对任务的描述，在执行过程中会打印出来。user 指定了调用 user 模块，name 是 user 模块里的一个参数，而增加的用户名字调用了上面 vars 中的 user 变量的值。 

如果想实现删除用户，只需要将该 playbook 文件的最后一行替换为如下行：
```markdown
user: name="{{user}}" state=absent remove=yes
```

#### 通过 PlayBook 安装 Apache 示例
通过 ansible-playbook 实现对多台主机同时安装 apache。需要注意的是，多台被管理主机的操作系统可能不同，从而apache包名不同。假设同时存在 CentOS 和 Debian 两种操作系统。具体 PlayBook 内容如下：
```markdown
# 安装 apache
- hosts: all
  remote_user: root
  gather_facts: True
  tasks:
    - name: install apache on CentOS
      yum: 
        name: httpd
        state: latest
      when: ansible_os_family == "CentOS"
    - name: install apache on Debian
      yum: 
        name: apache2
        state: latest
      when: ansible_os_family == "Debian"
```
以上 playbook 使用了 when 语句，同时也开启了 gather_facts setup 模块，这里的 ansible_os_family 变量就是直接使用 setup 模块获取的信息。如果有大量主机，就在运行的时候加上 -f 选项，然后指定一个合适的并发主机数量即可。

#### PlayBook 的构成

playbook 是由一个或多个 play 组成的列表，play 的主要功能在于将事先归并为一组的主机修饰成通过 ansible 中的 task 定义好的角色。从根本上来讲，task 其实就是调用 ansible 的一个 module。将多个 play 组织在一个 playbook 中，即可让他们联动起来按照事先编排的顺序共同完成任务。

PlayBook 主要由以下四部分组成：

* Target section：定义将要执行 playbook 的远程主机组。
* Variable section：定义 playbook 运行时需要使用的变量。
* Task section：定义将要在远程主机上执行的任务列表。
* Handler section：定义 task 执行完成以后需要调用的任务。

而其一般所需的目录层为如下五个：（视具体情况可变化）

* vars 变量层
* tasks 任务层
* handlers 触发条件
* files 文件
* template 模板

##### Hosts 和 Users

PlayBook 中的每一个 play 的目的都是为了让某个或某些主机以某个指定的用户身份执行任务。

* hosts：用于指定要执行指定任务的主机，可以是一个或多个由冒号分隔的主机组。
* remote_user：用于指定远程主机上的执行任务的用户。不过 remote_user 也可用于各 task 中，也可以通过指定 sudo 的方式在远程主机上执行任务，其可用于 play 全局或某任务。此外，还可以在 sudo 时，使用 sudo_user 指定 sudo 时切换的用户。
* user：与 remote_user 相同。
* sudo：如果设置为 yes，执行该任务组的用户在执行任务的时候，获取 root 权限。
* sudo_user：如果设置 user 为 xdhuxc，sudo 为 yes，sudo_user 为 wanghuan 时，则 xdhuxc 用户在执行任务时会获得 wanghuan 用户的权限。
* connection：连接到远程主机的方式，默认为 ssh。
* gather_facts：除非明确说明不需要在远程主机上执行 setup 模块，否则默认自动执行。如果确实不需要 setup 模块传递过来的变量，则可以将该选项设置为：False

示例如下：
```markdown
- hosts: webnodes
  tasks:
  - name: test ping connection
    remote_user: xdhuxc
    sudo: yes
```

##### 任务列表和 Action

play 的主体部分是任务列表。任务列表中的各任务按次序逐个在 hosts 中指定的所有主机上执行，即在所有主机上完成第一个任务后，再开始第二个。在自上而下运行某 playbook 时，如果中途发生错误，所有已执行任务都将回滚。因此，发生错误时，修正 playbook 后重新执行一次即可。

task 的目的是使用指定的参数执行模块，而在模块参数中可以使用变量。模块执行是幂等的，这意味着多次执行是安全的，因为其结果均一致。每个 task 都应该有其 name，用于 playbook 的执行结果输出，建议其内容尽可能清晰地描述任务执行步骤。如果未提供 name，则 action 的结果将用于输出。

定义 task 的可以使用 "action: module options" 或 "module: options" 的格式，推荐使用后者以实现向后兼容。如果 action 一行的内容过多，也可以使用在行首使用几个空白字符进行换行。

```markdown
tasks:
- name: make sure apache is running
  service: 
    name: httpd 
    state: running
```

在众多的模块中，只有 command 和 shell 模块仅需要给定一个列表，而无需使用“key=value”格式，例如
```markdown
tasks:
- name: disable selinux
  command: /sbin/setenforce 0
```

如果命令或脚本的退出码不为零，可以使用如下方式替代：
```markdown
task:
- name: run this command and ignore the result
  shell: /usr/bin/ls || /bin/true
```

使用 ignore_errors 来忽略错误信息
```markdown
task:
- name: run this command and ignore the result
  shell: /usr/bin/dockerd
  ignore_errors: True
```

##### handlers

handlers 用于当关注的资源发生变化时采取一定的操作。

notify 这个 action 可用于在每个 play 的最后被触发，这样可以避免多次有改变发生时，每次都执行指定的操作，取而代之仅在所有的变化发生完成后一次性地执行指定操作。

在 `notify` 中列出的操作称为 `handler`，也即 `notify` 中调用 `handler` 中定义的操作。

注意，在 `notify` 中定义内容一定要和 `task` 中定义的 `- name` 内容一样，这样才能达到触发的效果，否则会不生效。

```markdown
- name: template configuration file
    template: 
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart memcached
    - restart apache
```
handler 是 task 列表的这些 task，与前述的 task 并没有本质上的不同
```markdown
handlers:
- name: restart memcached
 service: 
   name: memcached
   state: restarted
- name: restart apache
 service:
   name: apache
   state: restarted 
```
##### tags
tags 用于让用户选择运行或略过 playbook 中的部分代码。ansible 具有幂等性，因此会自动跳过没有变化的部分，即便如此，有些代码为测试其确实没有发生变化的时间依然会非常地长。此时，如果确信其没有变化就可以通过 tags 跳过这些代码片段。
 
##### 完整的 PlayBook 示例

/etc/ansible/hosts 文件配置如下：
```markdown
[client]
10.10.24.32
```

一个安装 httpd web 服务器的示例 yaml

/etc/ansible/playbook/install_web.yaml
```markdown
- hosts: client
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is the latest version
    yum:
      name: httpd
      state: latest
  - name: write the apache config file
    template:
      src: /root/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running and enable it at boot
    service:
      name: httpd
      state: started
      enabled: yes
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted
```

在安装 ansible 的机器上，运行如下命令执行该 playbook
```markdown
[root@xdhuxc roles]# pwd
/etc/ansible/roles
[root@xdhuxc roles]# ls
install_web.retry  install_web.yaml
[root@xdhuxc roles]# ansible-playbook ./install_web.yaml 

PLAY [client] *************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [10.10.24.32]

TASK [ensure apache is the latest version] ********************************************************************************************************************************
ok: [10.10.24.32]

TASK [write the apache config file] ***************************************************************************************************************************************
changed: [10.10.24.32]

TASK [ensure apache is running and enable it at boot] *********************************************************************************************************************
changed: [10.10.24.32]

RUNNING HANDLER [restart apache] ******************************************************************************************************************************************
changed: [10.10.24.32]

PLAY RECAP ****************************************************************************************************************************************************************
10.10.24.32                : ok=5    changed=3    unreachable=0    failed=0   
```
