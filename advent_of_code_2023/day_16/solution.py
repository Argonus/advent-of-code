import time
class Solution:
    MOVEMENTS = {
        'up': (0, -1),
        'down': (0, 1),
        'left': (-1, 0),
        'right': (1, 0)
    }
    def __init__(self, input_file):
        self.grid = self.build_grid(input_file)
        self.visited = set()
        self.visited_moves = set()

    def part_one(self):
        movements = [((0, 0), 'right')]
        return self.traverse(movements)


    def part_two(self):
        min_x = min([x for x, y in self.grid.keys()])
        max_x = max([x for x, y in self.grid.keys()])
        min_y = min([y for x, y in self.grid.keys()])
        max_y = max([y for x, y in self.grid.keys()])

        left = max(self.traverse([((min_x, y), 'right')]) for y in range(min_y, max_y + 1))
        right = max(self.traverse([((max_x, y), 'left')]) for y in range(min_y, max_y + 1))
        top = max(self.traverse([((x, min_y), 'down')]) for x in range(min_x, max_x + 1))
        bottom = max(self.traverse([((x, max_y), 'up')]) for x in range(min_x, max_x + 1))

        return max(top, bottom, left, right)


    def traverse(self, movements):
        self.cleanup()

        while len(movements) > 0:
            pos, direction = movements.pop()
            self.visited_moves.add((pos, direction))
            self.visited.add(pos)

            if self.grid[pos] == '.':
                self.move_beam(movements, pos, direction)
            elif self.grid[pos] == '|':
                if direction in ['up', 'down']:
                    self.move_beam(movements, pos, direction)
                elif direction in ['left', 'right']:
                    self.move_beam(movements, pos, 'up')
                    self.move_beam(movements, pos, 'down')
            elif self.grid[pos] == '-':
                if direction in ['left', 'right']:
                    self.move_beam(movements, pos, direction)
                elif direction in ['up', 'down']:
                    self.move_beam(movements, pos, 'left')
                    self.move_beam(movements, pos, 'right')
            elif self.grid[pos] == '/':
                if direction == 'right':
                    self.move_beam(movements, pos, 'up')
                elif direction == 'left':
                    self.move_beam(movements, pos, 'down')
                elif direction == 'up':
                    self.move_beam(movements, pos, 'right')
                elif direction == 'down':
                    self.move_beam(movements, pos, 'left')
            elif self.grid[pos] == '\\':
                if direction == 'right':
                    self.move_beam(movements, pos, 'down')
                elif direction == 'left':
                    self.move_beam(movements, pos, 'up')
                elif direction == 'up':
                    self.move_beam(movements, pos, 'left')
                elif direction == 'down':
                    self.move_beam(movements, pos, 'right')

        return len(self.visited)

    def move_beam(self, movements_queue, pos, direction):
        next_pos = (pos[0] + self.MOVEMENTS[direction][0], pos[1] + self.MOVEMENTS[direction][1])
        next_move = (next_pos, direction)
        if next_pos in self.grid.keys() and next_move not in self.visited_moves:
            movements_queue.append(next_move)

    def cleanup(self):
        self.visited = set()
        self.visited_moves = set()

    def print_grid(self):
        min_x = min([x for x, y in self.grid.keys()])
        max_x = max([x for x, y in self.grid.keys()])
        min_y = min([y for x, y in self.grid.keys()])
        max_y = max([y for x, y in self.grid.keys()])

        for y in range(min_y, max_y + 1):
            for x in range(min_x, max_x + 1):
                pos = (x, y)
                if pos in self.visited:
                    print('#', end='')
                else:
                    print(self.grid[(x, y)], end='')
            print()

    @staticmethod
    def build_grid(input_file):
        grid = {}
        with open(input_file) as f:
            for row_idx, line in enumerate(f):
                for col_idx, char in enumerate(line.strip()):
                    grid[(col_idx, row_idx)] = char
        return grid

print("Solution one: ", Solution("input.txt").part_one())
print("Solution two: ", Solution("input.txt").part_two())