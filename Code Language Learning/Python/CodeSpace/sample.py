foo = "foo"
bar = "bar"

foobar = foo + bar  # 好的做法
foo += "ooo"  # 不好
foo = "".join([foo, "ooo"])  # 更好的方式
