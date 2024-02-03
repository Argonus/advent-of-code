lines = open("input.txt", "r").read().strip().split("\n")

s1 = 0
s2 = 0
vals = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9}

for line in lines:
    digits_s1 = []
    for element in line:
        if element.isdigit():
            digits_s1.append(int(element))

    digits_s2 = []
    for i,c in enumerate(line):
        if c.isdigit():
            digits_s2.append(int(c))
        for val in vals:
            if line[i:].startswith(val):
                digits_s2.append(vals[val])

    s1 += digits_s1[0] * 10 + digits_s1[-1]
    s2 += digits_s2[0] * 10 + digits_s2[-1]

print("Solution 1: ", s1)
print("Solution 2: ", s2)