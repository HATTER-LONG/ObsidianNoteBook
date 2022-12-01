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
   如果您不太清楚您应该使用哪种许可方式，请查看  [choosealicense.com](http://choosealicense.com/).
   当然，您也可以在发布您的代码时不做任何许可说明，但是这显然阻碍潜在的用户使用您的代码。
3. Setup.py
   用于打包和发布管理，如果模块包在根目录下，这个文件同样应该在一起。
4. Requirements File
   一个  [pip requirements file](https://pip.pypa.io/en/stable/user_guide/#requirements-files)  应该放在仓库的根目录。它应该指明完整工程的所有依赖包: 测试, 编译和文档生成。
   如果工程没有任何开发依赖，或者您喜欢通过  `setup.py`  来设置，那么这个文件不是必须的。
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
   - 将您的包安装到 site-packages 中。
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

   一些其他的常规管理脚本（比如  `manage.py`  或者  `fabfile.py`），也放在仓库的根目录下。

### 糟糕的结构特征

容易结构化的项目同样意味着它的结构化容易做得糟糕。糟糕结构的特征包括：

1. 多重且混乱的循环依赖关系。
2. 隐含耦合。
3. 大量使用全局变量或上下文。
4. 面条式代码。
5. Python 中更可能出现混沌代码：这类代码包含上百段相似的逻辑碎片，通常是缺乏 合适结构的类或对象，如果您始终弄不清手头上的任务应该使用 FurnitureTable， AssetTable 还是 Table，甚至 TableNew，也许您已经陷入了混沌代码中。

### 模块

Python 模块是最主要的抽象层之一，并且很可能是最自然的一个。抽象层允许将代码分为**不同部分**，每个部分包含相关的数据与功能。在代码中可以直接通过 `import` 和 `from ... import` 完成模块导入，并在当前文件中使用导入的模块接口。

1. 模块命名：
   - 为遵守风格指南中的规定，模块名称要短、使用小写，并避免使用特殊符号，比如点(.) 和问号(?)。如  `my.spam.py`  这样的名字是必须不能用的！该方式命名将妨碍 Python 的模块查找功能。
   - 如果愿意您可以将模块命名为  `my_spam.py`， 不过并不推荐在模块名中使用下划线。但是，在模块名称中使用其他字符（空格或连字号） 将阻止导入（-是减法运算符），因此请尽量保持模块名称简单，以无需分开单词。 最重要的是，不要使用下划线命名空间，而是使用子模块：

```ad-note
title: 命名

import library.plugin.foo # OK

import library.foo_plugin # not OK
```

2. 导入规则：
   - 具体来说，`import modu`  语句将 寻找合适的文件，即调用目录下的  `modu.py`  文件（如果该文件存在）。如果没有 找到这份文件，Python 解释器递归地在 `"PYTHONPATH"` 环境变量中查找该文件，如果仍没 有找到，将抛出 ImportError 异常。
   - 一旦找到  `modu.py`，Python 解释器将在隔离的作用域内执行这个模块。**所有顶层 语句都会被执行**，包括其他的引用。方法与类的定义将会存储到模块的字典中。然后，这个 模块的变量、方法和类通过命名空间暴露给调用方，这是 Python 中特别有用和强大的核心概念。
   - 但  `import *`  通常 被认为是不好的做法。**使用** `from modu import *` **的代码较难阅读而且依赖独立性不足**。 使用  `from modu import func`  能精确定位您想导入的方法并将其放到全局命名空间中。

````ad-note
title: 差
```python
[...]
from modu import *
[...]
x = sqrt(4)  # sqrt是模块modu的一部分么？或是内建函数么？上文定义了么？
````

````ad-note
title: 稍好
```python
from modu import sqrt
[...]
x = sqrt(4)  # 如果在import语句与这条语句之间，sqrt没有被重复定义，它也许是模块modu的一部分。
````

````ad-note
title: 最好
```python
import modu
[...]
x = modu.sqrt(4)  # sqrt显然是属于模块modu的。
````

### 包

任意包含  `__init__.py`  文件的目录都被认为是一个 Python 包。导入一个包里不同模块的方式和普通的导入模块方式相似，特别的地方是  `__init__.py`  文件将集合所有包范围内的定义。

- `pack/`  目录下的  `modu.py`  文件通过  `import pack.modu`  语句导入。 该语句会在  `pack`  目录下寻找  `__init__.py`  文件，并执行其中所有顶层语句。以上操作之后，`modu.py`  内定义的所有变量、方法和类在 pack.modu 命名空间中均可看到。
- 如果包内的模块和子包没有代码共享的需求，使用空白的  `__init__.py`  文件是正常甚至好的做法。
- 入深层嵌套的包可用这个方便的语法：`import very.deep.module as mod`。 该语法允许使用  mod  替代冗长的  `very.deep.module`。

## 面向对象编程

在 Python 中一切都是对象，并且能按对象的方式处理。但是 Python 并没有并没有将面向对象作为最主要的编程范式，Python 开发者有更多自由去选择不使用面向对象。
有时把有隐式上下文和副作用的函数与仅包含逻辑的函数(纯函数)谨慎地区分开来，会带来以下好处：
  - 纯函数的结果是确定的：给定一个输入，输出总是固定相同。
  - 当需要重构或优化时，纯函数更易于更改或替换。
  - 纯函数更容易做单元测试：很少需要复杂的上下文配置和之后的数据清除工作。
  - 纯函数更容易操作、修饰和分发。

### 装饰器

Python 语言提供一个简单而强大的语法：**装饰器**。装饰器是一个函数或类，它可以包装(或装饰)一个函数或方法。被 '装饰' 的函数或方法会替换原来的函数或方法。由于在Python中函数是一等对象它也可以被 '手动操作'，但是使用 `@decorators` 语法更清晰，因此首选这种方式。

```python
def foo():
    print("My name is foo")

def decorator(func):
    print(func)
    print("My name is decorator")
    return func

foo = decorator(foo)

@decorator
def bar():
    print("My name is bar")

if __name__ == "__main__":
    bar()

'''
output:

<function foo at 0x1056305e0>
My name is decorator
<function bar at 0x105c5fb00>
My name is decorator
My name is bar
'''
```

这个机制对于分离概念和避免外部不相关逻辑“污染”主要逻辑很有用处。 记忆化 <https://en.wikipedia.org/wiki/Memoization#Overview> 或缓存就是一个很好的使用装饰器的例子：您需要在table中储存一个耗时函数的结果，并且下次能直接 使用该结果，而不是再计算一次。这显然不属于函数的逻辑部分。

### 上下文管理器

上下文管理器式一个 Python 对象，为操作提供了额外的上下文信息。这种额外的信息，在使用 `with` 语句初始化上下文，以及完成 `with` 块中的所有代码时保存可以访问状态。如下打开文件：

```python
with open("./test.py") as f:
    content = f.read()
    print(content)
```

这样可以保证文件句柄 `f` 在脱离 `with` 作用域后会被释放。

实现这个功能有两种简单的方法：使用类或使用生成器。 让我们自己实现上面的功能，以使用类方式开始：

```python
class CustomOpen:
    def __init__(self, filename) -> None:
        self.file = open(filename)

    def __enter__(self):
        return self.file

    def __exit__(self, ctx_type, ctx_value, ctx_traceback):
        self.file.close()


with CustomOpen("./openfile.py") as f:
    content = f.read()
    print(content)
```
这只是一个常规的Python对象，它有两个由 `with` 语句使用的额外方法。 CustomOpen 首先被实例化，然后调用它的`__enter__` 方法，而且 `__enter__` 的返回值在 `as f` 语句中被赋给 `f` 。 当 `with` 块中的内容执行完后，会调用 `__exit__` 方法。