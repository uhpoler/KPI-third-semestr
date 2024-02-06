import json
import random
import numpy as np

class Problem:
    FILE_NAME = "problem.txt"

    def __init__(self):
        self.initialize_matrix()
        self.optimal_solution = self.find_optimal_solution()

    def get_cost(self, path):
        solution = 0
        for i in range(100):
            solution += self.get_distance(path[i], path[i + 1])
        return solution

    def get_distance(self, source, destination):
        return self.matrix[source][destination]

    def initialize_matrix(self):
        try:
            with open(self.FILE_NAME, 'r') as file:
                lines = file.readlines()
                self.matrix = [list(map(int, line.split())) for line in lines]
        except FileNotFoundError:
            self.matrix = [[0 if i == j else random.randint(5, 50) for j in range(100)] for i in range(100)]
            with open(self.FILE_NAME, 'w') as file:
                for row in self.matrix:
                    file.write(' '.join(map(str, row)) + '\n')



    #жадібний алгоритм обирає найближчу непройдену вершину
    def find_optimal_solution(self):
        solutions = []
        for j in range(100):
            nodes = list(range(100))
            current_node = j
            path = [current_node]
            for i in range(99):
                node = current_node
                #обирає найближчу до поточної непройдену вершину
                current_node = min(filter(lambda x: x not in path, nodes), key=lambda x: self.get_distance(node, x))
                path.append(current_node)
            path.append(j)
            solutions.append(self.get_cost(path))

        return min(solutions)


class AntAlgorithm:
    def __init__(self, problem):
        self.problem = problem
        self.pheromone_matrix = self.initialize_matrix()

    def iterate(self):
        paths = [self.find_path(random.randint(0, 99)) for _ in range(30)]
        self.update_pheromones(paths)

    def get_solution(self):
        path = [0]
        for i in range(1, 100):
            current_index = path[i - 1]
            pheromone_array = self.pheromone_matrix[current_index]
            max_pheromone = float('-inf')
            max_index = -1
            for j in range(1, 100):
                if j not in path:
                    if pheromone_array[j] > max_pheromone:
                        max_pheromone = pheromone_array[j]
                        max_index = j
            path.append(max_index)

        path.append(0)
        return path

    def get_probabilities(self, current_node, allowed_nodes):
        values = [(self.pheromone_matrix[current_node][allowed_node] ** 2) * (
                    1.0 / self.problem.matrix[current_node][allowed_node] ** 4)
                  for allowed_node in allowed_nodes]
        total = sum(values)

        if total == 0:
            return [0] * len(values)

        probabilities = [value / total for value in values]
        return probabilities

    def update_pheromones(self, paths):
        evaporation_rate = 1-0.4
        for i in range(100):
            for j in range(100):
                self.pheromone_matrix[i][j] *= evaporation_rate

        for path in paths:
            cost = self.problem.get_cost(path)
            for i in range(100):
                self.pheromone_matrix[path[i]][path[i + 1]] += self.problem.optimal_solution / cost

    def find_path(self, initial):
        result = [initial]
        to_visit = list(range(100))
        to_visit.remove(initial)
        for i in range(1, 100):
            probabilities = self.get_probabilities(result[i - 1], to_visit)
            node_index = self.choose_node(probabilities)
            result.append(to_visit[node_index])
            to_visit.pop(node_index)

        result.append(initial)
        return result

    @staticmethod
    def choose_node(probabilities):
        random_value = random.random()
        total = 0.0
        for i, prob in enumerate(probabilities):
            total += prob
            if total > random_value:
                return i
        return len(probabilities) - 1

    def initialize_matrix(self):
        return [[0.1 if i != j else 0 for j in range(100)] for i in range(100)]


if __name__ == "__main__":
    problem = Problem()
    algorithm = AntAlgorithm(problem)

    with open("result.txt", "w") as file:
        for i in range(50):
            for j in range(30):
                algorithm.iterate()

            optimal_path = algorithm.get_solution()
            optimal_cost = problem.get_cost(optimal_path)

            line = f"ітерація {30 * (i + 1)} вартість маршруту {problem.get_cost(algorithm.get_solution())}\n"
            print(line)

            file.write(line)

    print("Оптимальний шлях:", optimal_path)