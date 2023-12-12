from functools import cache

class Solution:
    def __init__(self):
        lines = open("input.txt", "r").read().strip().split("\n")
        self.springs = self.get_springs(lines)


    def part_one(self):
        combinations = 0
        for i, (springs, digits) in enumerate(self.springs):
            result = self.get_combinations(springs, digits[:])
            combinations += result

        return combinations

    # Full @cache solution stolen from good soul on reddit
    def part_two(self):
        combinations = 0
        for i, (springs, digits) in enumerate(self.springs):
            print("Processing spring {}".format(i))
            new_springs, new_digits = self.unfold_spring(springs[:], digits[:])
            result = self.get_combinations(new_springs, new_digits[:])
            combinations += result

        return combinations

    @cache
    def get_combinations(self, spring, digits):
        # End recursion
        if len(spring) == 0 and len(digits) == 0:
            return 1
        elif len(spring) == 0:
            return 0

        cursor = spring[0]
        if cursor == "#":
            # This one is invalid as cursor is # and we have no digits left to assign it
            if len(digits) == 0 or len(spring) < digits[0]:
                return 0
            # This one is invalid as there is a "." splitting the group
            elif "." in spring[0:digits[0]]:
                return 0
            # This one is invalid as there is a "#" just after the group
            elif len(spring[digits[0]:]) > 0 and spring[digits[0]:][0] == '#':
                return 0
            # This one is invalid as there is too many # in the group
            elif len(spring) > digits[0] and spring[0:digits[0] - 1].count("#") > digits[0]:
                return 0
            elif len(spring) > digits[0]:
                # This one may be valid, we can drop the cursor and continue
                if spring[digits[0]] == "?":
                    return self.get_combinations(spring[digits[0] + 1:].lstrip("."), digits[1:])


            return self.get_combinations(spring[digits[0]:].lstrip("."), digits[1:])
        # We can drop the cursor and following . and continue as group
        elif cursor == ".":
            return self.get_combinations(spring[:].lstrip("."), digits[:])
        elif cursor == "?":
            r1 = self.get_combinations('#' + spring[1:], digits[:])
            r2 = self.get_combinations('.' + spring[1:], digits[:])
            return r1 + r2

    @staticmethod
    def unfold_spring(spring, digits):
        digits = digits * 5
        spring = "?".join([spring for i in range(5)])

        return spring, digits

    @staticmethod
    def get_springs(lines):
        result = []
        for line in lines:
            springs, numbers = line.split(" ")
            digits = tuple([int(i) for i in numbers.split(",")])
            result.append((springs, digits))
        return result

print("Solution one: ", Solution().part_one())
print("Solution two: ", Solution().part_two())