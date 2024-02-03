import re
from collections import defaultdict
class Solution:
    def __init__(self):
        self.__input = open("input.txt", "r").read().strip().split(",")
        self.__regexp = re.compile(r"([a-zA-z]*)([-=]\d*)")

    def part_one(self):
        solution = 0
        for letters in self.__input:
            current_value = self.decode_string(letters)
            solution += current_value

        return solution

    def part_two(self):
        power = 0
        boxes = defaultdict(list)
        for letters in self.__input:
            box_label, operation = self.find_box_label_and_operation(letters)
            box_number = self.decode_string(box_label)
            self.apply_operation(boxes, box_number, box_label, operation)

        for box_number, entries in boxes.items():
            box_power = self.calculate_box_power(box_number, entries)
            power += box_power

        return power

    def find_box_label_and_operation(self, letters):
        group = re.search(self.__regexp, letters)
        label = group.group(1)
        operation = group.group(2)
        return label, operation

    @staticmethod
    def decode_string(letters):
        current_value = 0
        for letter in list(letters):
            current_value += ord(letter)
            current_value *= 17
            current_value %= 256

        return current_value

    def apply_operation(self, boxes, box_number, box_label, operation):
        if operation.startswith("="):
            self.add_to_box(boxes, box_number, box_label, operation)
        elif operation.startswith("-"):
            self.remove_from_box(boxes, box_number, box_label)
        else:
            raise ValueError("Operation not supported: ", operation)

    def add_to_box(self, boxes, box_number, box_label, operation):
        value = int(re.findall(r"\d+", operation)[0])
        index = self.find_index(boxes[box_number], box_label)
        if index is None:
            boxes[box_number].append((box_label, value))
        else:
            boxes[box_number][index] = (box_label, value)

    def remove_from_box(self, boxes, box_number, box_label):
        current_entries = boxes[box_number]
        new_entries = self.filter_entries(current_entries[:], box_label)
        boxes[box_number] = new_entries

    @staticmethod
    def filter_entries(entries, box_label):
        return [entry for entry in entries if not entry[0] == box_label]

    @staticmethod
    def find_index(entries, box_label):
        for index, entry in enumerate(entries):
            if entry[0] == box_label:
                return index

        return None

    @staticmethod
    def calculate_box_power(box_number, entries):
        if len(entries) == 0:
            return 0

        box_power = 0
        box_base = box_number + 1
        for idx, entry in enumerate(entries):
            entry_power = box_base * (idx + 1) * entry[1]
            box_power += entry_power

        return box_power





print("Solution one: ", Solution().part_one())
print("Solution two: ", Solution().part_two())