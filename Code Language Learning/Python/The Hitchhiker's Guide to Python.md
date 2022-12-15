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

Python 语言提供一个简单而强大的语法：**装饰器**。装饰器是一个函数或类，它可以包装(或装饰)一个函数或方法。被 '装饰' 的函数或方法会替换原来的函数或方法。由于在 Python 中函数是一等对象它也可以被 '手动操作'，但是使用 `@decorators` 语法更清晰，因此首选这种方式。

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

这个机制对于分离概念和避免外部不相关逻辑“污染”主要逻辑很有用处。  记忆化 <https://en.wikipedia.org/wiki/Memoization#Overview>  或缓存就是一个很好的使用装饰器的例子：您需要在 table 中储存一个耗时函数的结果，并且下次能直接 使用该结果，而不是再计算一次。这显然不属于函数的逻辑部分。

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

这只是一个常规的 Python 对象，它有两个由  `with`  语句使用的额外方法。 CustomOpen 首先被实例化，然后调用它的`__enter__` 方法，而且  `__enter__`  的返回值在  `as f`  语句中被赋给  `f` 。 当  `with`  块中的内容执行完后，会调用  `__exit__`  方法。

### 动态类型

Python 中的变量和其他语言有很大不同，其仅仅代表只想内存的“标签”，因此很可能上一秒还指向字符串的变量，下一刻变成了指向一个函数。这往往为调试增加了很大的困难，以下方法可以作为避免问题的参考：

- 避免对不同类型的对象使用同一个变量名称。

````ad-note
title: 差
```python
a = 1
a = "a string"

def func():
    print(a)

````

````ad-note
title:好
```python
count = 1
msg = "a string"

def func():
    print(msg)

````

- 使用简短的函数或方法能降低对不相关对象使用同一个名称的风险。即使是相关的不同类型的对象，也更建议使用不同命名：

````ad-note
title:差
```python
items = "a b c d"
items = items.split(" ")
items = set(items)  # 转变为集合
````

重复使用命名对效率没有提升：赋值时无论如何都会产生新的对象。然而随着复杂度的 提升，赋值语句被其他代码包括 'if' 分支和循环分开，使得更难查明指定变量的类型。

### 可变和不可变类型

Python 提供两种内置或用户定义的类型。

- 可变类型允许内容的内部修改。典型的动态类型，包括列表与字典：列表都有可变方法，如  `list.append()`  和  `list.pop()`，并且能就地修改，字典也是一样。
- 不可变类型没有修改自身内容的方法。比如，赋值为整数 6 的变量 x 并没有 "自增" 方法，如果需要计算 x + 1，必须创建另一个整数变量并给其命名。

```python
my_list = [1, 2, 3, 4, 5]
my_list[0] = 0
print(my_list)  # 源列表被修改

x = 6
x = x + 1  # x 是一个新的变量
```

这种差异导致的一个后果就是，可变类型是不稳定的，因而不能作为字典的键值使用。

- python 中字符串是不可变的类型，这意味着当需要组合一个字符串时，将每一个部分放到一个可变列表中再使用 `join` 方法组合起来的做法更高效。

````ad-note
title:差
```python
# 创建将 0 到 19 连接起来的字符串（例如"0123..171819"）
nums = ""

for n in range(20):
    nums += str(n)  # 每个字符串都要新建
print(nums)
````

````ad-note
title:好
```python
# 创建将 0 到 19 连接起来的字符串（例如"0123..171819"）
nums = []

for n in range(20):
    nums.append(str(n))
print("".join(nums))  # 更高效
````

````ad-note
title:更好
```python
# 创建将 0 到 19 连接起来的字符串（例如"0123..171819"）
nums = [str(n) for n in range(20)]
print("".join(nums))
````

````ad-note
title:最好
```python
# 创建将 0 到 19 连接起来的字符串（例如"0123..171819"）
nums = map(str, range(20))
print("".join(nums))
````

- 有时使用 `join` 并不是最好的选择，如果预先确定数量的字符串进行组合使用时加法操作更快，但在前边例子中的情况或添加已存在的字符串中时使用 `join` 更好：

```python
foo = "foo"
bar = "bar"

foobar = foo + bar  # 好的做法
foo += "ooo"  # 不好
foo = "".join([foo, "ooo"])  # 更好的方式
```

````ad-note
title:注解

除了 [`str.join()`](https://docs.python.org/3/library/stdtypes.html#str.join "(在 Python v3.7)") 和 `+`，您也可以使用 [%](https://docs.python.org/3/library/string.html#string-formatting "(在 Python v3.7)") 格式运算符来连接确定数量的字符串，但 [**PEP 3101**](https://www.python.org/dev/peps/pep-3101) 建议使用 [`str.format()`](https://docs.python.org/3/library/stdtypes.html#str.format "(在 Python v3.7)") 替代 `%` 操作符。
```python
foo = 'foo'
bar = 'bar'

foobar = '%s%s' % (foo, bar) # 可行
foobar = '{0}{1}'.format(foo, bar) # 更好
foobar = '{foo}{bar}'.format(foo=foo, bar=bar) # 最好
````

## 代码风格

### 一般概念

#### 明确的代码

在存在各种黑魔法的 Python 中，我们提倡最明确和直接的编码方式：

````ad-note
title:糟糕
```python
def make_complex(*args):
    x, y = args
    return dict(**locals())
````

````ad-note
title:优雅
```python
def make_complex(x, y):
    return {"real": x, "imag": y}
````

对比上边两个例子，好的示例中 x 和 y 以明确的字典形式返回，开发者在使用这个函数时，只阅读第一行和最后一行即可了解需要做什么，糟糕的示例中则没有这么明确。

#### 每一个声明

复合语句（比如说列表推导）因其简洁和表达性受到推崇，但在同一行代码中写两条独立的语句是糟糕的。

````ad-note
title:糟糕
```python
print("one");print("two");print("three")

if x == 1: print("one")

if <complex comparison> and <other complex comparison>:
    # do something
    pass
````

````ad-note
title:优雅
```python
print 'one'
print 'two'

if x == 1:
    print 'one'

cond1 = <complex comparison>
cond2 = <other complex comparison>
if cond1 and cond2:
    # do something
````

#### 函数参数

将参数传递给函数有四种不同的方式：

1. **位置参数**是强制的，且没有默认值。这是最简单的参数形式，它们是函数完整意义的一部分，并且其顺序是自然且符合直觉的。例如，`send(message, recipient)`  或  `point(x, y)`。
   - 当调用函数的时候可以使用参数名称来改变参数的顺序，但这降低了可读性并且带来不必要的冗长，并不推荐。例如，`send(recipient='World', message='Hello')`  和  `point(y=2, x=1)`。
2. **关键字参数**时非强制的，且有默认值。其被用来在传递给函数的**可选**参数中，当一个函数有超过两个或三个位置参数时，函数签名会变得难以记忆，使用带有默认参数的关键字参数将会带来帮助。例如，send(message, to, cc=None, bcc=None)，其中 cc 和 bcc 就是可选的，默认为 None。
3. **任意参数列表**。如果函数的目的是通过带有数目可扩展的位置参数的签名，可以使用 `*args` 结构，其中 `*args ` 是一个远足，它包含剩余的所有位置参数。例如，`send(message, *args)`，当如下调用`send('Hello', 'God','Mom', 'Cthulhu')`，在此函数体中， `args`  相当于  `('God', 'Mom', 'Cthulhu')`。
   - 这种结构存在一些函数签名不明确缺点，如果一个函数接受的参数列表具有相同的性质，通常将其定义成一个容器参数而不是使用任意参数列表，这样的定义更加的明确。例如，如果  `send`  参数有多个容器（recipients），将之定义成  `send(message, recipients)`  会更明确，调用它时就使用  `send('Hello', ['God','Mom', 'Cthulhu'])`，这样的话， 函数的使用者可以事先将容器列表维护成列表`list` 形式，这为传递各种不能被转变成其他序列的序列（包括迭代器）带来了可能。
4. **任意关键字参数字典**。如果函数要求一系列待定的命名参数，可以使用 `**kwargs` 这种结构。在函数体中， `kwargs`  是一个 字典，它包含所有传递给函数但没有被其他关键字参数捕捉的命名参数。
   - 和  *任意参数列表*  中所需注意的一样，相似的原因是：这些强大的技术是用在被证明确实需要用到它们的时候，它们不应该被用在能用更简单和更明确的结构，来足够表达函数意图的情况中。

编写函数的时候采用何种参数形式，是用位置参数、还是可选关键字参数、是否使用形如任意参数的高级技术，这些都由程序员自己决定。如果能明智地遵循上述建议，就可能且非常享受地写出这样的 Python 函数：

- 易读（名字和参数无需解释）
- 易改（添加新的关键字参数不会破坏代码的其他部分）

#### 避免魔法方法

Python 对开发者来说是一个强有力的工具，它拥有非常丰富的钩子 `hook` 和工具，允许您施展几乎任何形式的技巧。比如说，它能够做以下每件事：

- 改变对象创建和实例化的方式；
- 改变 Python 解释器导入模块的方式；
- 甚至可能（如果需要的话也是被推荐的）在 Python 中嵌入 C 程序。
- 尽管如此，所有的这些选择都有许多缺点。使用更加直接的方式来达成目标通常是更好的方法。它们最主要的缺点是可读性不高。许多代码分析工具，比如说 pylint 或者 pyflakes，将无法解析这种“魔法”代码。

我们认为 Python 开发者应该知道这些近乎无限的可能性，因为它为我们灌输了没有不可能完成的任务的信心。然而，知道如何，尤其是何时**不能**使用它们是非常重要的。

#### 返回值

当一个函数变得复杂，在函数体中使用多返回值的语句并不少见。然而，为了保持函数的明确意图以及持续可读的水平，更建议在函数体中避免使用返回多个有意义的值。

在函数中返回结果主要有两种情况：**函数正常运行结束返回结果**，以及**发生错误后返回失败信息**，要么因为一个错误的输入参数，要么因为其他导致函数无法完成计算或任务的原因。

如果当出错时不想抛出异常，返回一个值（比如说 `None` 或 `False` ）来表明函数无法正确运行，可能是需要的。在这种情况下，越早返回所发现的异常对上下文影响越小。但是当有多个出口点时，函数将会变得难以调试和返回其结果，所以保持单个出口点回更好。

```python
def complex_function(a, b, c):
    if not a:
        return None  # 抛出一个异常可能会更好
    if not b:
        return None  # 抛出一个异常可能会更好

    # 一些复杂的代码试着用 a,b,c 来计算 x
    # 如果计算成功需要进行有效性校验

    if not x:
        # 其他计算 x 的方式，进行挽救
        pass
    return x  # 返回 x 仅有一个出口点利于维护代码
```

### 习语

编程习语，说得简单些，就是写代码的*方式*。编程习语的概念在  [c2](http://c2.com/cgi/wiki?ProgrammingIdiom)  和  [Stack Overflow](http://stackoverflow.com/questions/302459/what-is-a-programming-idiom) 上有充足的讨论。

采用习语的 Python 代码通常被称为  *Pythonic*。

尽管通常有一种 --- 而且最好只有一种 --- 明显的方式去写得 Pythonic。对 Python 初学者来说，写出习语式的 Python 代码的*方式*并不明显。所以，好的习语必须有意识地获取。

如下有一些常见的 Python 习语：

#### 解包

如果您知道一个列表或者元组的长度，您可以将其解包并为它的元素取名。比如，`enumerate()`  会对 list 中的每个项提供包含两个元素的元组：

```python
for index, item in enumerate(some_list):
    # 使用index和item做一些工作
```

您也能通过这种方式交换变量：

```python
a, b = b, a
```

嵌套解包也可以：

```python
a, (b, c) = 1, (2, 3)
```

在 Python 3 中，扩展解包的新方法在  [**PEP 3132**](https://www.python.org/dev/peps/pep-3132)  有介绍：

```python
a, *rest = [1, 2, 3]
# a = 1, rest = [2, 3]
a, *middle, c = [1, 2, 3, 4]
# a = 1, middle = [2, 3], c = 4
```

#### 创建一个含 N 个对象的列表

使用 Python 列表中的 `*` 操作符：

```python
four_nones = [None] * 4
```

#### 创建一个含 N 个列表的列表

因为列表是可变的，所以  `*`  操作符（如上）将会创建一个包含 N 个且指向 _同一个_ 列表的列表，这可能不是您想用的。取而代之，请使用列表解析：

```python
four_lists = [[] for __ in range(4)]
```

#### 根据列表来创建字符串

创建字符串的一个常见习语是在空的字符串上使用  [`str.join()`](https://docs.python.org/3/library/stdtypes.html#str.join "(在 Python v3.7)") 。

```python
letters = ['s', 'p', 'a', 'm']
word = ''.join(letters)
```

这会将 word 变量赋值为 'spam'。这个习语可以用在列表和元组中。

#### 在集合体（collection）中查找一项

有时我们需要在集合中查找，常见的列表和集合（set）。如下代码举例：

```python
s = set(["s", "p", "a", "m"])
l = ["s", "p", "a", "m"]


def lookup_set(s):
    return "s" in s


def lookup_list(l):
    return "s" in l
```

即使这两个函数看起来一样，但是由 _查找集合_ 是利用哈西散列进行查找，对于长列表而言查找则会慢的多。在字典中查询也是同样的原理。想了解更多内容，请见[StackOverflow](http://stackoverflow.com/questions/513882/python-list-vs-dict-for-look-up-table) 。想了解在每种数据结构上的多种常见操作的花费时间的详细内容， 请见  [此页面](https://wiki.python.org/moin/TimeComplexity?)。

因为这些性能上的差异，在下列场合在使用集合或者字典而不是列表，通常会是个好主意：

- 集合体中包含大量的项
- 您将在集合体中重复地查找项
- 您没有重复的项

对于小的集合体，或者您不会频繁查找的集合体，建立哈希带来的额外时间和内存的开销经常会大过改进搜索速度所节省的时间。

### Python 之禅

又名  [**PEP 20**](https://www.python.org/dev/peps/pep-0020), Python 设计的指导原则。

```text
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!

Python之禅 by Tim Peters

优美胜于丑陋（Python以编写优美的代码为目标）
明了胜于晦涩（优美的代码应当是明了的，命名规范，风格相似）
简洁胜于复杂（优美的代码应当是简洁的，不要有复杂的内部实现）
复杂胜于凌乱（如果复杂不可避免，那代码间也不能有难懂的关系，要保持接口简洁）
扁平胜于嵌套（优美的代码应当是扁平的，不能有太多的嵌套）
间隔胜于紧凑（优美的代码有适当的间隔，不要奢望一行代码解决问题）
可读性很重要（优美的代码是可读的）
即便假借特例的实用性之名，也不可违背这些规则（这些规则至高无上）
不要包容所有错误，除非您确定需要这样做（精准地捕获异常，不写 except:pass 风格的代码）
当存在多种可能，不要尝试去猜测
而是尽量找一种，最好是唯一一种明显的解决方案（如果不确定，就用穷举法）
虽然这并不容易，因为您不是 Python 之父（这里的 Dutch 是指 Guido ）
做也许好过不做，但不假思索就动手还不如不做（动手之前要细思量）
如果您无法向人描述您的方案，那肯定不是一个好方案；反之亦然（方案测评标准）
命名空间是一种绝妙的理念，我们应当多加利用（倡导与号召）
```

### PEP8

[**PEP 8**](https://www.python.org/dev/peps/pep-0008)  是 Python 正在实施的代码风格指南，我们可以在  [pep8.org](http://pep8.org/)  上获得高质量的、最新的 PEP 8 版本。

### 约定

这里介绍一些应该遵循的约定，使得您编写的代码更加易读。

#### 检查变量是否等于常量

您不需要明确地比较一个值是 True、False 或者 None，可以仅仅把它放到 `if` 语句中。参阅  [真值测试](http://docs.python.org/library/stdtypes.html#truth-value-testing)  来了解什么被认为是 False。

````ad-note
title:糟糕
```python
if attr == True:
    print 'True!'

if attr == None:
    print 'attr is None!'
````

````ad-note
title:优雅
```python
# 检查值
if attr:
    print 'attr is truthy!'

# 或者做相反的检查
if not attr:
    print 'attr is falsey!'

# or, since None is considered false, explicitly check for it
if attr is None:
    print 'attr is None!'
````

#### 访问字典元素

不要使用  `dict.has_key()`  方法。取而代之，使用  `x in d`  语法，或者 将一个默认参数传递给  [`dict.get()`](https://docs.python.org/3/library/stdtypes.html#dict.get "(在 Python v3.7)")。

```python
d = {"hello": "word"}

print(d.get("hello", "default_value"))  # word
print(d.get("thingy", "default_value"))  # word

if "hello" in d:
    print(d["hello"])
```

#### 维护列表的捷径

[列表推导](http://docs.python.org/tutorial/datastructures.html#list-comprehensions)  提供了一个强大的而又简洁的方式来处理列表。而且， [`map()`](https://docs.python.org/3/library/functions.html#map "(在 Python v3.7)")  和  [`filter()`](https://docs.python.org/3/library/functions.html#filter "(在 Python v3.7)")  函数使用一种不同但是更简洁的语法处理列表。

1. 过滤列表：

````ad-note
title:糟糕
在迭代列表的过程中，永远不要从列表中移除元素。
```python
# 过滤大于 4 的元素
a = [3, 4, 5]
for i in a:
    if i > 4:
        a.remove(i)
````

**优雅的做法**:

Python 有一些标准的过滤列表的方法。 您要使用哪种方法取决于：

- Python 2.x vs. 3.x
- 列表 vs. 迭代器
- 修改原始列表可能产生的副作用

1. Python 2.x vs. 3.x：从 3.x 开始，[`filter()`](https://docs.python.org/3/library/functions.html#filter "(在 Python v3.7)")  函数返回迭代器而不是列表。 如果你真的需要一个列表，请使用  `list()`  将其包装。

```python
list(filter(...))
```

2. 列表与迭代器：创建新列表需要更多工作，并使用更多内存。如果您只是要遍历列表，请考虑使用迭代器。

```python
# 推导创建了一个新的列表对象
filtered_values = [value for value in sequence if value != x] # type list
# 生成器不会创建新的列表
filtered_values = (value for value in sequence if value != x) # type generator
# 3.x 迭代器
filtered_values = filter(lambda i: i != x, sequence)
```

3. 修改原始列表可能产生的副作用：如果有其他变量引用原始列表，则修改它可能会有风险。但如果你真的想这样做，你可以使用  *切片赋值（slice assignment）* 。

```python
# 修改原始列表的内容
sequence[::] = [value for value in sequence if value != x]
# 或者
sequence[::] = (value for value in sequence if value != x)
# 或者
sequence[::] = filter(lambda value: value != x, sequence)
```

#### 在列表中修改值

赋值永远不会创建新对象。如果两个或多个变量引用相同的列表，则修改其中一个变量意味着将修改所有变量。

````ad-note
title:糟糕
```python
# 所有列表成员都加 3
a = [3, 4, 5]

b = a  # a 和 b 指向同一个列表

for i in range(len(a)):
    a[i] += 3  # b[i] 也别改变

````

````ad-note
title:优雅
```python
a = [3, 4, 5]
b = a

# 给变量 "a" 赋值新的列表，而不改变 "b"
a = [i + 3 for i in a]  # 使用推导创建新的 list

a = list(map(lambda x: x + 3, a))  # 使用 map 创建新的 list
````

使用  [`enumerate()`](https://docs.python.org/3/library/functions.html#enumerate "(在 Python v3.7)")  获得列表中的当前位置的计数， [`enumerate()`](https://docs.python.org/3/library/functions.html#enumerate "(在 Python v3.7)")  函数比手动维护计数有更好的可读性。而且，它对迭代器进行了更好的优化。

```python
a = [3, 4, 5]

for i, item in enumerate(a):
    print(i, item)
# 打印
# 0 3
# 1 4
# 2 5
```

#### 读取文件

使用 `with open`  语法来读取文件。它将会为您自动关闭文件，因此 `with`  语句会更好，因为它能确保您总是关闭文件，即使是在  `with`  的区块中抛出一个异常。

````ad-note
title:糟糕
```python
f = open('file.txt')
a = f.read()
print a
f.close()
````

````ad-note
title:优雅
```python
with open('file.txt') as f:
    for line in f:
        print line
````

#### 行的延续

当一个代码逻辑行的长度超过可接受的限度时，您需要将之分为多个物理行。如果行的结尾是一个反斜杠，Python 解释器会把这些连续行拼接在一起。这在某些情况下很有帮助，但我们总是应该避免使用，因为它的脆弱性：如果在行的结尾，在反斜杠后加了空格，这会破坏代码，而且可能有意想不到的结果。
一个更好的解决方案是在元素周围使用括号。左边以一个未闭合的括号开头，Python 解释器会把行的结尾和下一行连接起来直到遇到闭合的括号。同样的行为适用中括号和大括号。

````ad-note
title:糟糕
```python
my_very_big_string = """For a long time I used to go to bed early. Sometimes, \
    when I had put out my candle, my eyes would close so quickly that I had not even \
    time to say “I’m going to sleep.”"""

from some.deep.module.inside.a.module import a_nice_function, another_nice_function, \
    yet_another_nice_function
````

````ad-note
title:优雅
```python
my_very_big_string = (
    "For a long time I used to go to bed early. Sometimes, "
    "when I had put out my candle, my eyes would close so quickly "
    "that I had not even time to say “I’m going to sleep.”"
)

from some.deep.module.inside.a.module import (
    a_nice_function, another_nice_function, yet_another_nice_function)
````

通常情况下，必须去分割一个长逻辑行意味着您同时想做太多的事，这可能影响可读性。

## 阅读好的代码

- [阅读好的代码](https://pythonguidecn.readthedocs.io/zh/latest/writing/reading.html#id1)

## 文档

### 项目文档

根目录下的  `README`  文件应该告诉用户和维护者关于项目的基本信息。它应该是原始文本，用一些非常容易阅读的标记，比如  [reStructuredText](https://pythonguidecn.readthedocs.io/zh/latest/writing/documentation.html#restructuredtext-ref)  或 Markdown。 它应该包含几行内容用来解释项目或者库的目的（假设用户不用知道任何关于该项目的事），软件主要源的 URL，以及一些基本的信用信息。此文件是代码阅读者的主要入口。

`INSTALL`  文件对 Python 来说并不必要。安装指令通常少至一条命令，比如说  `pipinstall module`  或  `python setup.py install` ，这被添加到  `README`  文件中。

`LICENSE`  文件应该  *总是*  存在的，而且应该指定向公众开放的软件许可。

`TODO`  文件或者位于  `README`  中的  `TODO`  区域应该列出代码的开发计划。

`CHANGELOG`  文件或者位于  `README`  中的  `CHANGELOG`  区域应该呈现对代码库的最新修改的简短概述。

### 项目发布

根据项目，您的文档中可能包含下列部分或所有的内容：

- 一份  *介绍*  应该用一两个极其简化的用例，来非常简短地概述该产品能够用来做什么。这是您的项目的 30 秒的自我陈述（thirty-second pitch）。
- 一份  *教程*  应该展示一些主要的用例，它要有更多细节。读者将会跟着一步步搭建工作原型。
- 一份  *API 参考*  通常从代码（参见  [docstrings](https://pythonguidecn.readthedocs.io/zh/latest/writing/documentation.html#docstring-ref)）中产生。 它会列出所有的可供公共访问的接口、参数和返回值。
- *开发人员文档*  适用于潜在贡献者。这可以包括项目的代码惯例和通用设计策略。

#### Sphinx

[Sphinx](http://sphinx.pocoo.org/)  无疑是最流行的 Python 文档工具。**请使用它吧。**  它能把  [reStructuredText](https://pythonguidecn.readthedocs.io/zh/latest/writing/documentation.html#restructuredtext-ref)  标记语言转换为广泛的输出格式，包括 HTML、LaTeX(可打印 PDF 版本)、手册页和纯文本。

[Read The Docs](http://readthedocs.org/)  是一个*超棒的*并且*免费的*文档托管，可以托管您的  [Sphinx](http://sphinx.pocoo.org/)  文档。 请使用它。您可以为它配置提交钩子到您的源库中，这样文档的重新构建将会自动进行。

运行时，Sphinx 将导入您的代码，并使用 Python 的内省功能，它将提取所有函数，方法和类签名。 它还将提取附带的文档字符串，并将其全部编译成结构良好且易于阅读的文档。

Sphinx 因 API 生成而著名，但它也适用于普通的项目文档。本指南使用  [Sphinx](http://sphinx.pocoo.org/)进行构建， 并托管在  [Read The Docs](http://readthedocs.org/)  上。

#### reStructuredText

大多数 Python 文档是用  [reStructuredText](http://docutils.sourceforge.net/rst.html)  编写的。它就像是内建了所有可选扩展的 Markdown。

[reStructuredText Primer](http://sphinx.pocoo.org/rest.html)  和  [reStructuredText Quick Reference](http://docutils.sourceforge.net/docs/user/rst/quickref.html)  应该会帮助您熟悉它的语法。

### 代码文档建议

注释能使代码清晰，将其加入到代码中是为了理解代码起来更容易。

在 Python 中， *文档字符串*用来描述模块、类和函数：

```python
def square_and_rooter(x):
    """返回自己乘以自己的平方根。"""
    pass
```

一般来说，要遵循  [**PEP 8#comments**](https://www.python.org/dev/peps/pep-0008#comments) （"Python 风格指南"）的注释部分。 更多关于文档字符串的内容可以在  [**PEP 0257#specification**](https://www.python.org/dev/peps/pep-0257#specification) （文档字符串约定指引） 上找到。

### 注释代码块

_不要使用三引号去注释代码_。 这不是好的实践，因为面向行的命令行工具， 比如说 grep，不会知道注释过的代码是没有激活的。对每一个注释行，使用带有合适缩进的 `#` 号会更好。您的编辑器可能很容易做到这一点，并能切换注释/取消注释。

#### 文档字符串和魔法

一些工具使用文档字符串来嵌入不止是文档的行为， 比如说单元测试逻辑。这些可能不错，但是简单地“保持文档就是文档”您永远都不会错。

像  [Sphinx](http://sphinx.pocoo.org/)  这样的工具会将您的文档字符串解析为 reStructuredText，并以 HTML 格式正确呈现。 这使得在示例代码片段中嵌入项目的文档非常简单。

此外， [Doctest](https://docs.python.org/3/library/doctest.html)  将读取所有内嵌的看起来像 Python 命令行输入（以“>>>”为前缀）的文档字符串并运行，以检查命令输出是否匹配其下行内容。这允许开发人员在源码中嵌入真实的示例和函数的用法。 此外，它还能确保代码被测试和工作。

```python
def my_function(a, b):
    """
    >>> my_function(2, 3)
    6
    >>> my_function('a', 3)
    'aaa'
    """
    return a * b
```

#### 文档字符串 vs 块注释

这些不可互换。对于函数或类，开头的注释区是程序员的注解。而文档字符串描述了函数或类的 *操作* ：

```python
# 由于某种原因这个函数减慢程序执行。
def square_and_rooter(x):
    """返回自己乘以自己的平方根。"""
    pass
```

与块注释不同，文档字符串内置于 Python 语言本身。与被优化掉的注释相比较，这意味着您可以使用 Python 强大的内省功能以在运行时获得文档字符串。对于几乎每个 Python 对象，可以通过其  **doc**  属性或使用内置的“help()”函数访问文档字符串。

块注释通常用于解释一段代码是  *做什么* ，或是算法的细节。而文档字符串更适合于向其他用户（或是写完代码 6 个月内的您）解释您代码中的特定功能是  *如何*  使用， 或是方法、类和模块的作用。

#### 编写文档字符串

取决于函数、方法或类的复杂度，使用单行文档字符串可能十分合适。 以下通常用于非常明显的情况，例如:

```python
def add（a，b）：
    """两个数字相加，并返回结果。"""
    return a + b
```

文档字符串应该以易于理解的方式描述函数。对于简单的例子，如简单的函数和类，简单地将函数的签名（即 `add(a, b) -> result`）嵌入到文档字符串中是不必要的。 这是因为使用 Python 的“inspect”模块可以很容易地找到这些信息。 此外，通过阅读源代码也可以很容易地获得。

然而，在更大或更复杂的项目中，提供相关功能的更多信息是个好主意，包括它是做什么的， 所抛的任何异常，返回的内容或参数的相关细节。

对于更详细的代码文档，用于 Numpy 项目的风格较为流行，通常称为  [Numpy style](http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html)  文档字符串。 虽然它之前的例子可能会占用更多的行，但它允许开发人员包含方法、函数或类的更多信息。

```python
def random_number_generator（arg1，arg2）：
    """
    摘要行。

    扩展功能描述。

    参数
    ----------
    arg1：int
        arg1的描述
    arg2：str
        arg2的描述

    返回
    -------
    int
        返回值说明

    """
    return 42
```

[sphinx.ext.napoleon](https://sphinxcontrib-napoleon.readthedocs.io/)  插件可以让 Sphinx 解析这种风格的文档字符串，使您可以轻松地将 NumPy 风格的文档输入到项目中。

最后，编写文档字符串的风格并没那么重要，它们的目的是为任何可能需要阅读或更改代码的人提供文档。只要它是正确的，可以理解的，切中相关点，那么它就完成了所设计的工作。

要进一步阅读 docstrings，请随时参见  [**PEP 257**](https://www.python.org/dev/peps/pep-0257)

## 测试代码

测试您的代码非常重要。常常将测试代码和运行代码一起写是一种非常好的习惯。 聪明地使用这种方法将会帮助您更加精确地定义代码的含义，并且代码的耦合性更低。

测试的通用规则：

- 测试单元应该集中于小部分的功能，并且证明它是对的。
- 每个测试单元必须完全独立。他们都能够单独运行，也可以在测试套件中运行而不用考虑被调用的顺序。要想实现这个规则，测试单元应该加载最新的数据集，之后再做一些清理。 这通常用方法  `setUp()`  和  `tearDown()`  处理。
- 尽量使测试单元快速运行。如果一个单独的测试单元需要较长的时间去运行，开发进度将会延迟，测试单元将不能如期常态性运行。有时候，因为测试单元需要复杂的数据结构，并且当它运行时每次都要加载，所以其运行时间较长。把运行吃力的测试单元放在单独的测试组件中，并且按照需要运行其它测试单元。
- 学习使用工具，学习如何运行一个单独的测试用例。然后，当在一个模块中开发了一个功能时，经常运行这个功能的测试用例，理想情况下，一切都将自动进行。
- 在编码会话前后，要常常运行完整的测试组件。只有这样，您才会坚信剩余的代码不会打断开发进度。
- 实现钩子（hook）是一个非常好的主意。因为一旦把代码放入分享仓库中，这个钩子可以运行所有的测试单元。
- 如果您在开发期间不得不打断自己的工作，写一个被打断的单元测试，它关于下一步要开发的东西。 当回到工作时，您将更快地回到原先被打断的地方，并且步入正轨。
- 当您调试代码的时候，首先需要写一个精确定位 bug 的测试单元。尽管这样做很难，但是捕捉 bug 的单元测试在项目中很重要。
- 测试函数使用长且描述性的名字。这边的样式指导与运行代码有点不一样，运行代码更倾向于使用短的名字，而测试函数不会直接被调用。在运行代码中，square()或者甚至 sqr()这样的命名都是可以的，但是在测试代码中，您应该这样取名 test_square_of_number_2()，test_square_negative_number()。当测试单元失败时，函数名应该显示，而且尽可能具有描述性。
- 当发生了一些问题，或者不得不改变时，如果代码中有一套不错的测试单元，维护将很大一部分依靠测试组件解决问题，或者修改确定的行为。因此测试代码应该尽可能多读，甚至多于运行代码。目的不明确的测试单元在这种情况下没有多少用处。
- 测试代码的另外一个用处是作为新开发人员的入门介绍。当有人需要基于现有的代码库工作时，运行并且阅读相关的测试代码是最好的做法。他们会或者应该发现大多数困难出现的热点，以及边界的情况。如果他们必须添加一些功能，第一步应该是添加一个测试，以确保新的功能不是一个尚未插入到界面的工作路径。

### 基本单元测试

[`unittest`](https://docs.python.org/3/library/unittest.html#module-unittest "(在 Python v3.7)")  包括 Python 标准库中的测试模型。任何一个使用过 Junit、nUnit 或 CppUnit 工具的人对它的 API 都会比较熟悉。

创建测试用例通过继承  [`unittest.TestCase`](https://docs.python.org/3/library/unittest.html#unittest.TestCase "(在 Python v3.7)")  来实现：

```python
import unittest


def func(x):
    return x + 1


class MyTest(unittest.TestCase):
    def test(self):
        self.assertEqual(func(3), 4)


if __name__ == "__main__":
    unittest.main()
```

### 文档测试

[`doctest`](https://docs.python.org/3/library/doctest.html#module-doctest "(在 Python v3.7)")  模块查找零碎的注释文本，就像在 Python 中 docstrings 内的交互式会话，执行那些会话以证实工作正常。
doctest 模块的用例相比之前的单元测试有所不同：它们通常不是很详细，并且不会用特别的用例或者处理模糊的回归 bug。作为模块和其部件主要用例的表述性文档，doctest 模块非常有用。

```python
def square(x):
    """
    返回 x 的平方

    >>> square(2)
    4
    >>> square(-2)
    5
    """
    return x * x


if __name__ == "__main__":
    import doctest

    doctest.testmod()
    
“”“
〉 python has_key.py          
**********************************************************************
File "has_key.py", 
line 7, in __main__.square
Failed example:
    square(-2)
Expected:
    5
Got:
    4
**********************************************************************
1 items had failures:
   1 of   2 in __main__.square
***Test Failed*** 1 failures.
”“”
```

### 工具
#### [pytest](https://docs.pytest.org/en/latest/)

相比于Python标准的单元测试模块，pytest是一个没有模板的选择。

```text
$ pip install pytest
```

尽管这个测试工具功能完备并且可扩展，但是它语法很简单。创建一个测试组件和写一个带有诸多函数的模块一样容易：
```python
# content of sum.py
def func(x):
    return x + 1


def test_func():
    assert func(3) == 5
```

输出：

```text
Learning ❯ pytest sum.py
============================================= test session starts ==============================================
platform darwin -- Python 3.11.0, pytest-7.2.0, pluggy-1.0.0
rootdir: /Python/CodeSpace
collected 1 item

sum.py F                                                                                                 [100%]

=================================================== FAILURES ===================================================
__________________________________________________ test_func ___________________________________________________

    def test_func():
>       assert func(3) == 5
E       assert 4 == 5
E        +  where 4 = func(3)

sum.py:7: AssertionError
=========================================== short test summary info ============================================
FAILED sum.py::test_func - assert 4 == 5
============================================== 1 failed in 0.06s ===============================================

```

#### mock

[`unittest.mock`](https://docs.python.org/3/library/unittest.mock.html#module-unittest.mock "(在 Python v3.7)") 是Python中用于测试的一个库。在Python3.3版本中，[标准库中就有包含](https://docs.python.org/dev/library/unittest.mock)。
