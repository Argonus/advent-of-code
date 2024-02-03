from collections import defaultdict
from collections import deque as Queue

class Solution:
    # x, y are reversed in the matrix
    MOVEMENTS = {
        'up': (0, -1),
        'down': (0, 1),
        'left': (-1, 0),
        'right': (1, 0),
    }
    SYMBOLS = {
        '|': ('up', 'down'),
        '-': ('left', 'right'),
        'L': ('up', 'right'),
        'J': ('up', 'left'),
        '7': ('left', 'down'),
        'F': ('right', 'down'),
        # We assume that the start can go in all directions.
        'S': ('up', 'down', 'right', 'left'),
        '.': ()
    }

    def __init__(self):
        lines = open("input.txt", "r").read().strip().split("\n")
        self.grid = self.build_grid(lines)
        self.graph = self.build_graph(lines)
        self.start = self.get_start()

    def part_one(self):
        visited = []
        self.bfs_traverse(visited, [])
        return len(visited) // 2

    def part_two(self):
        visited = []
        self.bfs_traverse(visited, [])
        return self.count_inside(visited)


    def bfs_traverse(self, visited, queue):
        queue.append(self.start)
        visited.append(self.start)

        while queue:
            node = queue.pop(0)
            for neighbour in self.graph[node]:
                if neighbour not in visited and self.grid[neighbour] != '.':
                    visited.append(neighbour)
                    queue.append(neighbour)

    def count_inside(self, visited):
        max_x, max_y = max(x for (x, y) in self.grid), max(y for (x, y) in self.grid)
        counter = 0

        for y in range(max_y + 1):
            inside = False
            corner = None
            for x, c in [(x, self.grid[x, y]) for x in range(max_x + 1)]:
                if (x, y) in visited:
                    # Vertical bound is changing the `in` line state.
                    #  S---
                    #  ||
                    if self.vertical_bound(c):
                        inside = not inside
                    elif self.left_corner(c):
                        corner = c
                    elif self.opposite_corner(corner, c):
                        inside = not inside
                else:
                    # We add only ones that are not visited.
                    counter += inside
        return counter

    @staticmethod
    def vertical_bound(char):
        return char == '|' or char == 'S'

    @staticmethod
    def left_corner(char):
        return char == 'L' or char == 'F'

    @staticmethod
    def opposite_corner(line_corner, char):
        return (line_corner == "F" and char == "J") or (line_corner == "L" and char == "7")


    @staticmethod
    def build_grid(lines):
        matrix = {}
        for y, line in enumerate(lines):
            for x, char in enumerate(list(line)):
                matrix[x, y] = char
        return matrix

    @staticmethod
    def build_graph(lines):
        matrix = defaultdict(list)
        for y, line in enumerate(lines):
            for x, char in enumerate(list(line)):
                movements = Solution.SYMBOLS[char]
                for dir in movements:
                    (dx, dy) = Solution.MOVEMENTS[dir]
                    if x + dx >= 0 and y + dy >= 0:
                        matrix[x, y].append((x + dx, y + dy))
        return matrix


    def get_start(self):
        for key, value in self.grid.items():
            if value == 'S':
                return key

print("Solution one: ", Solution().part_one())
print("Solution two: ", Solution().part_two())