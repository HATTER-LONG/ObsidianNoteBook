import requests

if __name__ == "__main__":
    r = requests.get("https://www.google.com")
    print(r.text)
