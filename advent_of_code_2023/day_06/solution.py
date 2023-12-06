import re
class Solution:
    def __init__(self):
        times, records = open("input.txt", "r").read().strip().split("\n")
        times = map(int, re.findall(r"\d+", times))
        records = map(int, re.findall(r"\d+", records))
        self.races = list(zip(times, records))

    def run_part_one(self):
        result = 1
        for time, record in self.races:
            left = self.run_race(time, record, range(1, time, 1))
            right = self.run_race(time, record, range(time, 0, -1))

            combinations = right - left + 1
            result *= combinations

        return result

    def run_part_two(self):
        times = []
        distances = []

        for i, (time, distance) in enumerate(self.races):
            times.append(f"{time}")
            distances.append(f"{distance}")

        time = int("".join(times))
        record = int("".join(distances))

        left = self.run_race(time, record, range(1, time, 1))
        right = self.run_race(time, record, range(time, 0, -1))

        return right - left + 1

    def run_race(self, race_time, race_record, rage_range):
        acc = 0
        for warmup_time in rage_range:
            time_left = race_time - warmup_time
            if time_left * warmup_time > race_record:
                acc = warmup_time
                break

        return acc




print("Solution one: ", Solution().run_part_one())
print("Solution two: ", Solution().run_part_two())