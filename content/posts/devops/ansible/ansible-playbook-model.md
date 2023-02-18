+++
title = "Ansible Playbook 常用模块示例"
linktitle = "Ansible Playbook 常用模块示例"
date = "2023-02-18"
lastmod = "2023-02-18"
description = ""
tags = [
    "Ansible",
    "DevOps"
]
categories = [
    "技术"
]
+++

本篇博客介绍了一些在 Ansible Playbook 中常用的模块的用法。

<!--more-->

使用 ansible 的一个原则是将某个功能拆分成幂等的若干个步骤，每个步骤只完成一个幂等的小功能，这样，我们的 ansible playbook 就可以多次重复运行，有效保证任务运行结果。

接下来，我们介绍一些常用的 ansible playbook 模块，使用这些模块，可以协助我们完成各项运维功能。

### shell
shell 模块可能是使用最频繁的模块了，用于执行一段用户编写的 shell 脚本。

使用方法为：
```markdown
- name: "clear current deploy"
  shell: |
    if [[ -f ansible.zip ]]; then
        rm -f ansible.zip
    fi
    if [[ -d __MACOSX ]]; then
        sudo rm -rf __MACOSX
    fi
  args:
    chdir: /Users/xdhuxc
```
各字段说明：
* name：表示当前任务的名称
* shell：说明当前使用 shell 模块，值为需要在机器上执行的 shell 脚本。
* args：用来表示其他一些参数
  * chdir 表示在此目录下执行 shell 脚本。

### stat
stat 模块用来检测目标机器上的文件或目录状态，然后将其注入到一个变量中，在后面的任务中可以使用这个变量来作为任务是否执行的条件。

使用方法为：
```markdown
- name: "check directory exists"
  stat: 
    path: "/var/lib/docker"
  register: docker-data-dir
```
各字段说明：
* name：表示当前任务的名称
* stat：表示当前任务使用 stat 模块
  * path 字段用来指定需要检测的目标机器上的文件或目录绝对路径
* register：会将检测注入到此变量中，可以在之后的任务中使用此变量。
    
在此 stat 之后的任务中，我们可以增加 when 来作为任务是否执行的条件，比如
```markdown
- name: "create docker data directory"
  become: true
  shell: "mkdir -p /var/lib/docker"
  environment:
    SUDO_PASSWORD: "{{ ansible_become_pass }}"
  when: docker-data-dir.stat.isdir is defined and docker-data-dir.stat.isdir and docker-data-dir.stat.exists == False
```

### file
file 模块可以用来对文件或者目录进行操作，比如创建、删除等。

使用方法为：
```markdown
- name: "delete old folder"
  ansible.builtin.file:
    path: "/var/lib/docker"
    state: absent
  when: docker-data-dir.stat.isdir is defined and docker-data-dir.stat.isdir and docker-data-dir.stat.exists == True  
```
各字段说明：
* name：表示当前任务的名称
* ansible.builtin.file：表示当前任务使用 file 模块，也可以简写为 file，
  * path 用来指定目标机器上的目录或文件，
  * state 表示文件或者目录的预期状态，state 为 absent 用来删除文件或者目录
* when：表示执行此任务的条件，在这个例子中，只有当目录存在时，我们才去删除它。

### get_url
get_url 模块用来从远程地址下载文件，压缩包等。

使用方法为：
```markdown
- name: "download zip file"
  ansible.builtin.get_url:
    url: "http://8.9.10.11/xdhuxc/tomcat.zip"
    dest: "/users/xdhuxc/java"
    mode: "0755"
```
各字段说明：
* name：表示当前任务的名称
* ansible.builtin.get_url：表示当前任务使用 get_url 模块，也可以简写为 get_url
  * url：表示待下载的文件的远程地址
  * dest：下载文件后在本机的存储地址
  * mode：文件在机器上的权限

### unarchive
unarchive 用来解压文件，可以指定远程文件，也可以指定本地文件，还允许指定解压参数。

使用方法为：
```markdown
- name: "unarchive zip file"
  ansible.builtin.unarchive:
    src: "/users/xdhuxc/tomcat.zip"
    dest: "/users/xdhuxc/java"
    remote_src: yes
    extra_opts:
      - -q
```
各字段说明：
* name：表示当前任务的名称
* ansible.builtin.unarchive：表示当前任务使用 unarchive 模块，也可以简写为 unarchive
  * src：表示待解压的文件的路径。
  * dest：表示解压后的目标目录。
  * remote_src：为 yes 时表示解压远程目标机器上的压缩文件
  * extra_opts：是一个字符串数组，可以填写一些解压缩时的参数，比如 -q，不向标准输出输出解压缩过程。











