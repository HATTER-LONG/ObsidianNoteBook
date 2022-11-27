# The Hitchhiker's Guide to Python

## 环境配置

1. pyenv 使用记录：
   1. 查看并安装指定版本：
      - `pyenv install --list`
      - `pyenv install <version>`
      - `pyenv install -v <version>` ，若发生错误查看详细信息。
   2. 控制当前环境信息：
      - `pyenv which python` ，显示当前 python 路径。
      - `pyenv global <version>` ，设置默认 python 版本。
      - `pyenv local <version>` ，当前路径创建 .python-version 文件，进入此目录后会自动切换为设定的 python 版本。
      - `python shell <version>` ，当前 shell 的 session 中启动某个版本，优先级高于 global 和 local。
2. pyenv virtualenv 使用：
   1. 创建指定版本虚拟环境：
      - `pyenv virtualenv <version> <env name>` ，创建指定版本与名称的虚拟环境。
      - `echo '<env name>' >> .python-version` ，同样可以配合 version 文件进行管理。
   2. 使用虚拟环境：
      - `pyenv activate <env name>` ，激活指定虚拟环境。
      - `pyenv deactivate` ，退出虚拟环境。
   3. 删除指定虚拟环境：
      - `pyenv uninstall <env name>`
      - `pyenv virtualenv-delete <env name>`
3. 冻结 (`freeze`) 环境，便于他人保持与开发环境一致：
   - `pip freeze > requirements.txt` ，这将会创建一个  `requirements.txt`  文件，其中包含了当前环境中所有包及各自的版本的简单列表。
   - `pip install -r requirements.txt` ，这能帮助确保安装、部署和开发者之间的一致性。

## 工程结构

```ad-note 
title: 仓库示例

[navdeep-G/samplemod (github.com)](https://github.com/navdeep-G/samplemod)

-------------------------------

README.rst

LICENSE

setup.py

requirements.txt

sample/__init__.py

sample/core.py

sample/helpers.py

docs/conf.py

docs/index.rst

tests/test_basic.py

tests/test_advanced.py

```

1. 核心模块
    `sample` 作为仓库的核心模块应该在根目录建立文件夹：
      - `./sample/`
    如果只有单个文件，其应该直接放在根目录下，不应该放在一个模棱两可的子目录，例如 `src` 、`python` 。
      - `./sample.py`
2. License
    除了源代码本身以外，这个毫无疑问是您仓库最重要的一部分。在这个文件中要有完整的许可说明和授权。
    如果您不太清楚您应该使用哪种许可方式，请查看 [choosealicense.com](http://choosealicense.com/).
    当然，您也可以在发布您的代码时不做任何许可说明，但是这显然阻碍潜在的用户使用您的代码。
3. Setup.py
    用于打包和发布管理，如果模块包在根目录下，这个文件同样应该在一起。
4. Requirements File
    一个 [pip requirements file](https://pip.pypa.io/en/stable/user_guide/#requirements-files) 应该放在仓库的根目录。它应该指明完整工程的所有依赖包: 测试, 编译和文档生成。
    如果工程没有任何开发依赖，或者您喜欢通过 `setup.py` 来设置，那么这个文件不是必须的。
5. Documentation
    包的参考文档，没有任何理由把这个放到除根目录外别的地方。
6. Test Suit
    单元测试，编写方式详见 [Testing Your Code — The Hitchhiker's Guide to Python (python-guide.org)](https://docs.python-guide.org/writing/tests/)
    最开始测试通常可以放在一个文件中：
      - `./test_sample.py`
    随着测试的增多，可以将其分为多个文件放到一个目录中：
      - `./test/test_basic.py`
      - ``./test/test_advanced.py`
    当然，这些测试例子需要导入您的包来进行测试，有几种方式来处理:
      - 将您的包安装到site-packages中。
      - [通过简单直接的路径设置来解决导入的问题](https://pythonguidecn.readthedocs.io/zh/latest/writing/structure.html#test-suite "永久链接至标题")
7. MakeFile
    make 对于定义常规的管理任务是很方便的工具：
    ```makefile
    init:
    pip install -r requirements.txt
    
    test:
        py.test tests
        
    .PHONY: init test
    ```
    一些其他的常规管理脚本（比如 `manage.py` 或者 `fabfile.py`），也放在仓库的根目录下。

### 糟糕的结构特征
容易结构化的项目同样意味着它的结构化容易做得糟糕。糟糕结构的特征包括：
1. 多重且混乱的循环依赖关系。
2. 隐含耦合。
3. 大量使用全局变量或上下文。
4. 面条式代码。
5. Python中更可能出现混沌代码：这类代码包含上百段相似的逻辑碎片，通常是缺乏 合适结构的类或对象，如果您始终弄不清手头上的任务应该使用FurnitureTable， AssetTable还是Table，甚至TableNew，也许您已经陷入了混沌代码中。