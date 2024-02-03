import re

lines = open("input.txt", "r").read().strip().split("\n")

cubes = { 'red': 12, 'green': 13, 'blue': 14 }

games = []

# Solution 1
for line in lines:
    valid = True
    game = line.strip().split(": ")
    game_num = int("".join(re.findall(r'\d+', game[0])))
    game_sets = game[1].strip().split("; ")

    for set in game_sets:
        vals = { 'red': 0, 'green': 0, 'blue': 0 }

        set_inputs = set.strip().split(", ")

        for set_input in set_inputs:
            color = re.findall(r'[a-z]+', set_input)[0]
            count = int("".join(re.findall(r'\d+', set_input)))
            vals[color] += count

        if vals['red'] > cubes['red'] or vals['green'] > cubes['green'] or vals['blue'] > cubes['blue']:
            valid = False

    if valid:
        games.append(game_num)

print("Solution 1: ", sum(games))

counter = 0
# Solution 2
for line in lines:
    vals = { 'red': 0, 'green': 0, 'blue': 0 }
    game = line.strip().split(": ")
    game_sets = game[1].strip().split("; ")

    for set in game_sets:
        set_inputs = set.strip().split(", ")

        for set_input in set_inputs:
            color = re.findall(r'[a-z]+', set_input)[0]
            count = int("".join(re.findall(r'\d+', set_input)))

            if vals[color] < count:
                vals[color] = count

    game_counter = vals['red'] * vals['green'] * vals['blue']
    counter += game_counter

print("Solution 2: ", counter)