import requests


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
