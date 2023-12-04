import re
from collections import defaultdict

lines = open("input.txt", "r").read().strip().split("\n")

# Solution 1
solution_one = 0

for line in lines:
    [card, vals] = line.split(": ")
    [winning, input] = vals.split(" | ")

    card_val = -1
    for i in re.findall(r"\d+", input):
        if i in re.findall(r"\d+", winning):
            card_val += 1

    if card_val >= 0:
        solution_one += pow(2, card_val)

print("Solution 1: ", solution_one)

# Solution 2
cards = defaultdict(lambda: 0)

for line in lines:
    [card, vals] = line.split(": ")
    [winning, input] = vals.split(" | ")
    card_num = int(re.findall(r"\d+", card)[0])

    cards[card_num] += 1
    card_power = card_num

    for i in re.findall(r"\d+", input):
        if i in re.findall(r"\d+", winning):
            card_power += 1
            cards[card_power] += cards[card_num]

solution_two = sum(cards.values())
print("Solution 2: ", solution_two)