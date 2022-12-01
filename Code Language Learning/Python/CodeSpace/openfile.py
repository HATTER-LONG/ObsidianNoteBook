def openfile():
    with open("./test.py") as f:
        content = f.read()
        print(content)


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
