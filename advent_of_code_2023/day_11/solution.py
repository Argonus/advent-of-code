import itertools
from collections import defaultdict
class Solution:
    def __init__(self):
        lines = open("input.txt", "r").read().strip().split("\n")
        self.grid = self.build_grid(lines)
        self.expanded_cols = []
        self.expanded_rows = []
        self.debug = False

    def part_one(self):
        counter = 0
        self.expand_universe()
        pairs = self.find_pairs(2)

        for pair in pairs:
            distance = self.get_distance(pair[0], pair[1])
            counter += distance

        return counter

    def part_two(self):
        counter = 0
        self.expand_universe()
        pairs = self.find_pairs(1_000_000)

        for pair in pairs:
            distance = self.get_distance(pair[0], pair[1])
            counter += distance

        return counter

    @staticmethod
    def get_distance(start, end):
        (x1, y1), (x2, y2) = start, end
        xdiff = abs(x2 - x1)
        ydiff = abs(y2 - y1)
        return xdiff + ydiff

    def find_pairs(self, expansion_factor):
        pairs = []
        points = []

        for y, row in enumerate(self.grid):
            for x, char in enumerate(row):
                if char != ".":
                    expanded_cols = [i for i in self.expanded_cols if i < x]
                    expanded_rows = [i for i in self.expanded_rows if i < y]
                    new_x = x + (len(expanded_cols) * (expansion_factor - 1)) if x > 0 else x
                    new_y = y + (len(expanded_rows) * (expansion_factor - 1)) if y > 0 else y
                    points.append((new_x, new_y))

        for point_a, point_b in itertools.combinations(points, 2):
            pairs.append((point_a, point_b))

        return pairs

    def expand_universe(self):
        row_length = len(self.grid[0])
        column_length = len(self.grid)

        for i in range(column_length):
            valid_row = True
            for j in range(row_length):
                if self.grid[i][j] != ".":
                    valid_row = False
                    break
            if valid_row:
                self.expanded_rows.append(i)

        for j in range(row_length):
            valid_col = True
            for i in range(column_length):
                if self.grid[i][j] != ".":
                    valid_col = False
                    break
            if valid_col:
                self.expanded_cols.append(j)

    @staticmethod
    def print_grid(grid):
        for row in grid:
            print("".join(row))

    @staticmethod
    def build_grid(lines):
        grid = []
        for line in lines:
            grid.append(list(line))
        return grid

print("Solution one:", Solution().part_one())
print("Solution two:", Solution().part_two())