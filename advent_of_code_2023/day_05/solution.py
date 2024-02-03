from itertools import islice

seeds_data = open("input.txt", "r").read().strip().split("\n\n")
maps = []

class Solution:
    def __init__(self):
        self.seeds_data = open("input.txt", "r").read().strip().split("\n\n")
        self.maps = self.build_maps(seeds_data[1:])

    def run_part_one(self):
        seeds_one = map(int, self.seeds_data[0].split(": ")[1].split(" "))
        return self.apply_transforms(seeds_one,[])

    def run_part_two(self):
        ranges = []
        results = []
        seeds_list = self.seeds_data[0].split(": ")[1].split(" ")
        seeds_chunks = self.chunk(seeds_list, 2)
        [ranges.append(range(int(s), int(s) + int(r))) for s, r in seeds_chunks]
        [results.append(self.apply_range_transforms(r)) for r in ranges]

        return self.flatten(results)


    def apply_transforms(self, init_seeds, acc):
        for seed in init_seeds:
            for map in self.maps:
                for dest, src, rng in map:
                    if seed in range(src, src + rng):
                        seed = dest + seed - src
                        break
            acc.append(seed)

        return acc

    def apply_range_transforms(self, seed_range):
        for map in self.maps:
            for dest, src, rng in map:
                s = []
                src_end = src + rng
                before = (seed_range.start(), min(seed_range.end(), src))
                inter = (max(seed_range.start(), src), min(src_end, seed_range.end()))
                after = (max(src_end, seed_range.start()), seed_range.end())

                if before[1] > before[0]:
                    s.append(before)
                if inter[1] > inter[0]:
                    s.append((inter[0]-src+dest, inter[1]-src+dest))
                if after[1] > after[0]:
                    s.append(after)

        return s

    def build_maps(self, maps_data):
        init_maps = []
        for map_data in maps_data:
            transforms = []
            for n in map_data.split(" map:\n")[1:]:
                for line in n.split("\n"):
                    transforms.append(list(map(int, line.split(" "))))
            init_maps.append(transforms)

        return init_maps

    def chunk(self, list, size):
        list = iter(list)
        return iter(lambda: tuple(islice(list, size)), ())

    def flatten(self, list):
        flat_list = []
        for sublist in list:
            for item in sublist:
                flat_list.append(item)

        return flat_list

s1 = Solution()
result = s1.run_part_one()
print("Solution 1: ", min(result))

s2 = Solution()
result = s2.run_part_two()
print("Solution 2: ", min(result))