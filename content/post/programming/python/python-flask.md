+++
title = "基于 Flask 开发 Python Web 程序"
date = "2018-02-27"
lastmod = "2018-03-27"
tags = [
    "Python",
    "Flask"
]
categories = [
    "技术"
]
+++

本篇博客详细介绍了一个使用 Flask 开发的 Python web 程序，可以作为使用 Flask 开发 web 程序的入门教程。

<!--more-->

### 安装 Flask 环境
1、Flask 依赖两个外部库： Werkzeug 和 Jinja2 。Werkzeug 是一个 WSGI 套件。 WSGI 是 Web 应用与 多种服务器之间的标准 Python 接口，即用于开发，也用于部署。 Jinja2 是用于渲染 模板的。

2、virtualenv的基本原理是为每个项目安装一套 Python ，多套 Python 并存。但它不是真正地安装多套独立的 Python 拷贝，而是使用了一种巧妙的方法让不同的项目处于各自独立的环境中。使用虚拟环境可以方便地安装 Flask 并且可以在系统的 Python 解释器中避免包的混乱和版本冲突。Python 3.3 以后原生支持虚拟环境，命令为：pyvenv。

1）安装虚拟 `Python` 环境，在 `Linux` 或者 `Windows` 下，使用如下命令：
```markdown
sudo pip install virtualenv
或
sudo easy_install virtualenv
```
在 `Ubuntu` 中使用如下命令：
```markdown
sudo apt-get install python-virtualenv
```

2）使用virtualenv命令在文件夹中创建 Python 虚拟环境
```markdown
virtualenv venv
```

3）每次需要使用项目时，必须先激活相应的环境

CentOS 下运行如下命令：
```markdown
. venv/bin/activate
```
`Windows` 下运行如下命令：
```markdown
.\venv\Scripts\activate
```

如果要退出虚拟环境，可以使用
```markdown
.\venv\Scripts\deactivate.bat
```

4）安装 flask
```markdown
sudo pip install flask
```


### Flask 程序结构

1、使用 PyCharm 新建 Flask 项目后，项目结构如下图所示：
<center>
<img src="/image/programming/python/flask/WechatIMG667.png" width="300px" height="200px" />
</center>
只有三个文件夹（venv文件夹已经用命令行生成）和一个简单地入口类。

2、改造为标准的 Flask 项目

在命令行中依次使用以下命令来安装 Flask 扩展。
```markdown
E:\PycharmProject\xflask>.\venv\Scripts\activate

(venv) E:\PycharmProject\xflask>pip install flask-script
(venv) E:\PycharmProject\xflask>pip install flask-sqlalchemy
(venv) E:\PycharmProject\xflask>pip install flask-migrate
```

flask-script 可以自定义命令行命令，用来启动程序或其他任务；flask-sqlalchemy用来管理数据库的工具，支持多种数据库后台；flask-migrate是数据库迁移工具，该工具命令集成到 flask-script中，方便在命令行中进行操作。
创建 config.py 文件，内容如下：
```markdown
import os

basedir = os.path.abspath(os.path.dirname(__file__))

class config:    
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'this is a secret string' 
    SQLALCHEMY_TRACK_MODIFICATIONS = True  

    @staticmethod    
    def init_app(app):        
        pass

class DevelopmentConfig(config):    
    DEBUG = True    
    SQLALCHEMY_DATABASE_URI = os.environ.get('DEV_DATABASE_URL') or \        
    'sqlite:///' + os.path.join(basedir, 'dev')

class TestingConfig(config):    
    TESTING = True    
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL') or \                              
    'sqlite:///' + os.path.join(basedir, 'test')

class ProductionConfig(config):    
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \                              
    'sqlite:///' + os.path.join(basedir, 'data.sqlite')

config = {    
    'development': DevelopmentConfig,    
    'testing': TestingConfig,    
    'production': ProductionConfig,    
    'default': DevelopmentConfig
}
```
config 保存了一些配置变量，SQLALCHEMY_DATABASE_URI 变量在不同的配置中被赋予了不同的值，这样就可以在不同的环境中切换数据库。如果是远程数据库，则从环境变量中读取URL，否则在本地路径中创建。

创建一个 app 目录，并在此目录中创建一个 `__init__.py` 文件
```markdown
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import config

db = SQLAlchemy()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    db.init_app(app)

    return app
```
Create_app() 就是程序的工厂函数，参数就是配置类的名称，即config.py，其中保存的配置可以使用from_object()方法导入。

路由和视图函数：
客户端把请求发送给 web服务器，web服务器再把请求发送给 Flask 程序实例，Flask程序实例需要知道每个URL请求要运行哪些代码，所以保存了一个URL到Python函数的映射关系。处理URL和函数之间关系的程序称为路由，这个函数称为视图函数。例如：
```markdown
@app.route('/')
def index():
    return '<h1>Hello World</h1>'
```
这里使用app.route修饰器来定义路由，app指Flask程序实例对象，后面可以看到使用蓝本管理路由后，由蓝本实例对象来取代app。Flask 使用蓝本来定义路由，在蓝本中定义的路由处于休眠状态，直到蓝本注册到程序上后，路由真正成为程序的一部分。蓝本通常使用结构化的方式保存在包的多个模块中。

接下来在app目录中创建一个子目录main，并在main目录中创建文件 `__init__.py`，在 `__init__.py` 中添加如下内容：
```markdown
from flask import Blueprint

# 实例化 Blueprint 类，两个参数分别为蓝本的名字和蓝本所在包或模块，第二个通常填 __name__ 即可
main = Blueprint('main', __name__)


from . import views, errors
```
最后引用了两个文件，写在最后是为了避免循环导入依赖，因为接下来在 main 目录下创建的views.py 和 errors.py 都要导入蓝本 main。

在main目录下创建 views.py
```markdown
from flask import render_template

# 导入蓝本 main
from . import main


@main.route('/')
def index():
    return render_template('index.html')
```
在路由的概念解释中，index函数直接返回了HTML字符串，通常不这么做。这里则使用了render_template()函数来渲染index.html，并返回。Flask 使用了 Jinja2引擎来渲染模板，模板文件都放在templates目录下，并且该目录只能命名为templates，否则Jinja2会抛出TemplateNotFound异常。

由于app是一个Python Package（在目录中包含__init__.py的目录默认成为Python Pckage），所以需要将templates放在app目录下，在app目录下创建templates目录。然后在templates下创建一个index.html和404.html模板。
index.html文件内容如下：
```markdown
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>
<h1>Hello World</h1>
</body>
</html>
```
404.html内容如下：
```markdown
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Not Found</title>
</head>
<body>
<h1>Can't find request page!</h1>
</body>
</html>
```

定义errors.py，内容如下：
```markdown
from flask import render_template
from . import main


@main.app_errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404
```

让程序的路由保存在views.py中，而错误处理交给errors.py，这两个模块已经和蓝本main关联起来了（在蓝本中导入了这两个模块）。现在需要在工厂函数中注入蓝本main，将如下代码加入到app/__init__.py中
```markdown
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import config
from .main import main as main_blueprint

db = SQLAlchemy()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    db.init_app(app)

    # 在工厂函数中注册蓝本 main
    app.register_blueprint(main_blueprint)
    return app
```

创建requirements.txt，程序中必须包含一个requirements.txt文件，用于记录所有的依赖包和其版本号，便于在其他电脑上创建相同的开发环境。直接在终端下使用如下命令创建requirements.txt文件：
```markdown
pip freeze > requirements.txt
```
以后安装了新的依赖包或者升级版本后，重新执行该命令即可更新requirements.txt文件。

如果需要在另外一台电脑上创建这个虚拟环境的完全副本，运行如下命令：
```markdown
pip install -r requirements.txt
```

创建启动脚本 manage.py
```markdown
import os
from app import create_app, db
from flask_script import Manager, Shell
from flask_migrate import Migrate, MigrateCommand

app = create_app(os.getenv('FLASK_CONFIG') or 'default')
manager = Manager(app)
migrate = Migrate(app, db)


def make_shell_context():
    return dict(app=app, db=db)


manager.add_command("shell",Shell(make_context=make_shell_context))
manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
```
这个脚本首先创建程序，然后增加了两个命令：shell和db，后续可以在命令行中直接使用。

到目前为止，我们的flask程序目录结构如下：
<center>
<img src="/image/programming/python/flask/WechatIMG668.jpeg" width="500px" height="200px" />
</center>

接下来，运行我们的程序，在命令行中进入E:\PycharmProject\xflask>目录，执行如下命令即可运行程序：
```markdown
python manage.py runserver
```
命令行运行截图如下：
<center>
<img src="/image/programming/python/flask/WechatIMG669.png" width="500px" height="200px" />
</center>

Flask 默认的本机地址为：http://127.0.0.1:5000或者http://localhost:5000，可以在浏览器中访问，如下图所示，可以按“Ctrl + C”退出程序。

<center>
<img src="/image/programming/python/flask/WechatIMG670.png" width="500px" height="200px" />
</center>

此时，默认只能本地访问网站，如果需要其他人也可以访问，需要指定0.0.0.0这个IP，就需要再加入参数，指定主机和端口，这样其他人访问时，只需要输入机器的IP地址，再加上端口就可以了。
```markdown
python manage.py runserver --host 0.0.0.0 --port 8080
```
在终端中使用上述命令启动程序

<center>
<img src="/image/programming/python/flask/WechatIMG671.png" width="500px" height="200px" />
</center>

在浏览器中访问如下：
<center>
<img src="/image/programming/python/flask/WechatIMG672.png" width="500px" height="200px" />
</center>


#### 一个 Flask 项目的标准结构

Flask 项目有四个顶级目录：

* app：Flask程序保存在此目录中。
* migrations：包含数据库迁移脚本。
* tests：单元测试放在此目录下。
* venv：Python虚拟环境。

同时还有一些文件，

* requirements.txt：列出了所有的依赖包，以便于在其他机器环境中重新生成相同的环境。
* config.py：存储配置。
* manage.py：启动程序或者其他任务。
* gun.conf：Gunicorn配置文件。
         








