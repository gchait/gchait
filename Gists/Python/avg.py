from decimal import Decimal


with open("nums.txt", "r") as f:
    l = f.read().strip().split("\n")

l = [Decimal(n) for n in l]
total = sum(l)
length = len(l)
print(f"{total=}")
print(f"{length=}")
print(f"{(total / length)=}")
