import re
from math import lcm
class Solution:
    def __init__(self, debug = False):
        route_map, lines = open("input.txt", "r").read().strip().split("\n\n")
        lines_list = lines.split("\n")
        self.route_map = [x for x in route_map]
        self.nodes = self.build_nodes(lines_list)
        self.debug = debug

    def part_1(self):
        counter, current_node = 0, "AAA"

        while current_node != "ZZZ":
            for route in self.route_map:
                counter += 1
                current_node = self.next_node(current_node, route)
                if current_node == "ZZZ":
                    break

        return counter

    def part_2(self):
        steps, starting_nodes = [], [x for x in self.nodes if x.endswith("A")]

        for node in starting_nodes:
            node_route, counter, current_node = [], 0, node

            while current_node.endswith("Z") is False:
                for route in self.route_map:
                    node_route.append((route, current_node))
                    counter += 1
                    current_node = self.next_node(current_node, route)
                    if current_node.endswith("Z"):
                        break

            steps.append(counter)
            if self.debug:
                print("For node: ", node, "route: ", node_route)

        # That works only because each starting node falls into a cycle of constant length
        return lcm(*steps)


    @staticmethod
    def build_nodes(lines_list: list[str]) -> dict[str, list[str]]:
        nodes = {}
        for line in lines_list:
            node, values = line.split(" = ")
            nodes[node] = re.findall(r"\w+", values)
        return nodes

    def next_node(self, node: str, route: str) -> str:
        if route == "L":
            return self.nodes[node][0]
        else:
            return self.nodes[node][1]


print("Solution one: ", Solution().part_1())
print("Solution two: ", Solution().part_2())
