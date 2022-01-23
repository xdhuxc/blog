+++
title = "Linux 中 Shell 脚本示例"
date = "2017-12-10"
lastmod = "2017-12-19"
tags = [
    "Linux",
    "Shell"
]
categories = [
    "Linux",
    "Shell"
]
+++

本篇博客记录了些 Linux Shell 脚本的典型示例代码，以备后查。

<!--more-->

### 读取输入
```markdown
#!/usr/bin/env bash

function set_kubernetes_prometheus() {
    while [ 0 ] ;
    do
        echo -n "请输入三个参数（以空格分隔开）:"
        stty erase ^H
        read P1 P2 P3
        if [ -n "${P1}" -a -n "${P2}" -a -n "${P3}" ] ; then
            break
        fi
    done

    echo "参数 1 为：${P1}"
    echo "参数 2 为：${P2}"
    echo "参数 3 为：${P3}"
}
```

### 计算三个数中的最大数
```markdown
#!/bin/bash
# author：xdhuxc
# time：2017-07-19
# description：计算三个数中的最大数

echo "Please enter three numbers:"
	# -p，允许在read命令行中直接指定一个提示。
	read -p "The first number is :" x
	read -p "The second number is :" y
	read -p "The third number is : " z
max = $x
if [ $y -ge $max ]; then
   max = $y
fi
if [ $z -ge $max ]; then
   max = $z
fi
echo "The maximum number is $max"
```

### 计算100以内的偶数的和
```markdown
#!/bin/bash
# author: xdhuxc
# time: 2017-07-19
# description：计算100以内的偶数的和
sum = 0
for i in $(seq 1 100); do
	if [ $[$i % 2] -eq 0 ]; then
		let sum += $i
	fi
done
echo "The sum is $sum."

sum = 0
for ((i=1; i<= 100; i++))
do
	if [ $[$i % 2] -eq 0 ]; then
		let sum += $i
	fi
done
echo "The sum is $sum."
```

### 在某个目录下的所有文件中查找关键字
```markdown
#!/bin/bash
# author: xdhuxc
# time: 2017-12-04
# description：在某个目录下的所有文件中查找关键字，输出匹配文件的全路径
# parameter 1：根目录名
# parameter 2：查找关键字
function traverse_dir(){
    local base_dir=$1
    local key=$2

    #set -x
    for file in $base_dir/*
    do
        if [ -d $file ]; then
            traverse_dir $file $key
        else
            grep -w $key $file > /dev/null
            if [ $? -eq 0 ]; then
                    echo -e $file
            fi
        fi
    done
}

traverse_dir $1 $2
```

### 加载 docker 镜像
```markdown
#!/bin/bash
# author: xdhuxc
# time: 2017-12-04
# description：加载当前目录下的tar格式镜像，更改镜像标签，再导出为tar格式镜像

# 加载当前目录下的镜像
for tar_image in ./*.tar
do
	if [ -f $tar_image ]; then
		docker load -i $tar_image
	fi
done

# 更改镜像标签
docker images | awk 'NR > 1 {print $1, $2}' | while read old_image_name tag
do
	#new_image_name=${old_image_name//10.10.24.171/192.168.244.128}
	new_image_name=${old_image_name#*\/}
	# 修改镜像标签
	docker tag $old_image_name:$tag $new_image_name:$tag
	# 删除旧的标签
	docker rmi -f $old_image_name:$tag
        # 导出为tar格式镜像
	tar_name=${new_image_name##*\/}-${tag}.tar
	docker save $new_image_name:$tag -o $tar_name 
done
```

### 删除已经退出的docker镜像
```markdown
#!/bin/bash
# author: xdhuxc
# time: 2017-12-04
# description：删除已经退出的docker镜像

# 删除已经退出的容器
docker ps -a | awk 'NR > 1 {print $1}' | while read container_id
do
    status=$(docker inspect --format={{.State.Status}} $container_id)
	if [ "$status"x = "exited"x ]; then
		docker rm -f $container_id > /dev/null
	fi
done
```

### 删除所有镜像
```markdown
#!/bin/bash

# 更改镜像标签 yonyoucloud-middleware/mesos-master 1.4.0 
docker images | awk 'NR > 1 {print $1, $2}' | while read old_image_name tag
do
	# 删除镜像
	docker rmi $old_image_name:$tag
done
```

### 替换某文件中的键值对
```markdown
# 替换某文件中的键值对

# 参数1：带文件路径的文件名
# 参数2：键
# 参数3：值
# jdbc.url=jdbc.mysql
# 描述：如果文件中没有该键，则添加该键值对；如果有，则更新键的值

function replace_text(){
    full_path_file=$1
    key=$2
    value=$3
    grep "${key}=" ${full_path_file} > /dev/null 2>&1
    if [ "$?" == "0" ] ; then
        # 获取 key-value所在的行

        echo "存在键${key}，其值为：${old_value}，替换其值为：${value}"
        #sed "s/${key}=//g" ${full_path_file}
        sed "s/${key}=${old_value}/${key}=${value}/g" ${full_path_file}
    else
        echo "不存在键 ${key}，添加键值对：${key}=${value}"
        echo "${key}=${value}" >> ${full_path_file}
    fi
}
```

### 使用cat命令向文件中追加内容
> 两个EOF之间的内容左端顶格，因为其之间的内容会原样追加到文件中
```markdown
#!/usr/bin/env bash

cat >> /etc/profile << EOF
export RUN_AS_USER=root
export JAVA_HOME=${nexus_shell_dir}/jdk1.7.0_80
export PATH=$JAVA_HOME/bin:$PATH
EOF
source /etc/profile
echo ${RUN_AS_USER}
```

### expect 的使用
```markdown
#!/usr/bin/env bash

# 安装 expect
command -v expect > /dev/null 2>&1
if [ "$?" != "0" ] ; then
    echo -e "当前机器尚未安装 expect。"
    echo -e "使用 yum 安装 except..."
    yum install -y expect 
fi

if [ $(command -v expect) ] ; then
    # 生成 ssh key
    chmod +x ssh-keygen.exp 
    ./ssh-keygen.exp > /dev/null 2>&1

    # 复制 ssh key 到各机器
    cat hosts | while read line
    do
        echo -e "${line}" > ./host.tmp
        cat host.tmp | awk -F '[: ]' '{print $1, $2, $3, $4}' | while read target_host username password port
        do
        	echo -e ${target_host}
        	echo -e ${username}
        	echo -e ${password}
                echo -e ${port}
        	if [ -n ${target_host} -a -n ${username} -a -n ${password} ] ; then
            		./ssh-copy-id.exp ${target_host} ${username} ${password} ${port}
        	fi
	done
    done
fi 
```

### 获取当前脚本的路径
```markdown
current_path=$(cd "$(dirname "$0")"; pwd)
full_path=$(realpath $0)
```
执行结果为：
```
/xdhuxc/script/tools
/xdhuxc/script/tools/test.sh
```


