import re
from math import comb
class Solution:
    def __init__(self, debug = False):
        self.history = open("input.txt", "r").read().strip().split("\n")
        self.nre = re.compile(r'(-?\d+)')
        self.debug = debug

    def part_1(self):
        solution = 0
        for line in self.history:
            y_values = [int(x) for x in self.nre.findall(line)]
            x_values = [i for i, x in enumerate(y_values)]
            x = max(x_values) + 1

            solution += self.lagrange_interpolation(x_values, y_values, x)

        return round(solution)

    def part_2(self):
        solution = 0
        for line in self.history:
            y_values = [int(x) for x in self.nre.findall(line)]
            x_values = [i for i, x in enumerate(y_values)]
            solution += self.lagrange_interpolation(x_values, y_values, -1)

        return round(solution)

    @staticmethod
    def lagrange_interpolation(x_values, y_values, x):
        y = 0
        n = len(y_values)

        for i in range(n):
            xi, yi = x_values[i], y_values[i]
            term = yi
            for j in range(n):
                if i == j:
                    continue

                xj = x_values[j]
                term *= (x - xj) / (xi - xj)
            y += term
        return y

print("Solution one: ", Solution().part_1())
print("Solution two: ", Solution().part_2())