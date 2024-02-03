import re
from collections import defaultdict

lines = open("input.txt", "r").read().strip().split("\n")

solution_one = 0
matrix = {}

# Build matrix with coordinates, so we can use them later.
# It's not most efficient way, but it works and it's easy to understand.
for row_idx, row in enumerate(lines):
    for col_idx, col in enumerate(row.strip()):
        matrix[(col_idx, row_idx)] = col

max_y = len(lines[0]) - 1
max_x = len(lines) - 1

# Solution 1
for row_idx, row in enumerate(lines):
    # Number returns a match object with idx of an element
    for number in re.finditer(r"\d+", row):
        result = False
        x = range(max(number.start() - 1, 0), min(number.end() + 1, max_x))
        y = range(max(row_idx - 1, 0), min(row_idx + 2, max_y))

        for i in x:
            for j in list(y):
                value = matrix[(i, j)]
                if not value.isdigit() and value != ".":
                    result = True

        if result:
            solution_one += int(number.group())

# Solution 2
solution_two = 0
gears = defaultdict(set)

for row_idx, row in enumerate(lines):
    # Number returns a match object with idx of an element
    for number in re.finditer(r"\d+", row):
        x = range(max(number.start() - 1, 0), min(number.end() + 1, max_x))
        y = range(max(row_idx - 1, 0), min(row_idx + 2, max_y))

        for i in x:
            for j in list(y):
                value = matrix[(i, j)]
                if value == "*":
                    gears[(i, j)].add(int(number.group()))

for nums in gears.values():
    if len(nums) == 2:
        solution_two += nums.pop() * nums.pop()

print("Solution 1: ", solution_one)
print("Solution 2: ", solution_two)
