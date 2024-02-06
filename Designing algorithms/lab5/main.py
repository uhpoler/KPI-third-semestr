import random
from pathlib import Path

class GeneticAlgorithm:
    PopulationSize = 1000
    BreedingPoolSize = 100
    def __init__(self, batch_number, probability, problem):
        self.problem = problem
        self.mutation_probability = probability
        self.batch_size = self.problem.CityNumber // batch_number
        self.current_generation = self.get_initial_population()

    def get_best_solution(self):
        return min(self.current_generation, key=lambda s: s.cost)


    #Алгоритм жадібної вставки
    def improve_solution(self, solution):
        for i in range(len(solution.path)):
            city = solution.path.pop(i)
            best_insertion_index = 0
            best_insertion_cost = float('inf')
            for j in range(len(solution.path) + 1):
                new_path = solution.path[:]
                new_path.insert(j, city)
                new_solution = Solution(self.problem, new_path)
                new_cost = new_solution.cost
                if new_cost < best_insertion_cost:
                    best_insertion_index = j
                    best_insertion_cost = new_cost
            solution.path = solution.path[:best_insertion_index] + [city] + solution.path[best_insertion_index:]
        return solution

    # 2-opt метод
    def improve_solution2(self, solution):
        for i in range(len(solution.path) - 1):
            for j in range(i + 1, len(solution.path)):
                if solution.path[i] == solution.path[j]:
                    continue
                new_path = solution.path[:]
                new_path[i], new_path[j] = new_path[j], new_path[i]
                new_path[i + 1:j] = solution.path[i + 1:j]
                new_path[j + 1:] = solution.path[j + 1:]
                new_solution = Solution(self.problem, new_path)
                if new_solution.cost < solution.cost:
                    return new_solution
        return solution

    def iterate(self):
        breeding_pool = sorted(self.current_generation, key=lambda s: s.cost)[:self.BreedingPoolSize]
        best = breeding_pool[:self.BreedingPoolSize // 5]
        probabilities = self.get_probabilities(breeding_pool)
        new_population = []

        for i in range(self.problem.CityNumber):
            if i < self.BreedingPoolSize // 5:
                new_population.append(best[i])
            else:
                new_population.append(self.cross(breeding_pool[self.choose_solution(probabilities)],
                                                breeding_pool[self.choose_solution(probabilities)]))
                if random.random() < self.mutation_probability:
                    self.mutate(new_population[i])


        #new_population = [self.improve_solution2(s) for s in new_population]
        self.current_generation = new_population

    def mutate(self, solution):
        first = random.randint(0, len(solution.path) - 1)
        second = random.randint(0, len(solution.path) - 1)
        solution.path[first], solution.path[second] = solution.path[second], solution.path[first]

    def cross(self, first, second):
        first_genes = [first.path[self.batch_size * 2 * (i // self.batch_size) + i % self.batch_size]
                       for i in range(self.problem.CityNumber // 2)]

        path = [0] * self.problem.CityNumber
        current_second = 0
        for i in range(self.problem.CityNumber):
            if (i // self.batch_size) % 2 == 0:
                path[i] = first.path[i]
            else:
                while first_genes.count(second.path[current_second]):
                    current_second += 1
                path[i] = second.path[current_second]
                current_second += 1
        return Solution(self.problem, path)

    def choose_solution(self, probabilities):
        rand = random.random()
        total = 0.0
        for i, prob in enumerate(probabilities):
            total += prob
            if total > rand:
                return i
        return len(probabilities) - 1

    #обчислює ймовірності вибору кожного рішення для формування нового покоління.
    def get_probabilities(self, solutions):
        values = [1.0 / s.cost for s in solutions]
        total = sum(values)
        return [val / total for val in values]

    def get_initial_population(self):
        return [Solution(self.problem, list(range(self.problem.CityNumber))).shuffle()
                for _ in range(self.PopulationSize)]


class Problem:
    FileName = "problem.txt"
    CityNumber = 300

    def __init__(self):
        self.initialize_matrix()

    def get_cost(self, path):
        solution = 0
        for i in range(self.CityNumber - 1):
            solution += self.get_distance(path[i], path[i + 1])
        solution += self.get_distance(path[self.CityNumber - 1], path[0])
        return solution

    def get_distance(self, source, destination):
        return self.matrix[source][destination]

    def find_optimal_solution(self):
        solutions = [self.get_cost(self.construct_path(j)) for j in range(self.CityNumber)]
        return min(solutions)

    def construct_path(self, start_node):
        nodes = list(range(self.CityNumber))
        current_node = start_node
        path = [current_node]
        for _ in range(self.CityNumber - 1):
            node = current_node
            current_node = min((x for x in nodes if x not in path), key=lambda x: self.get_distance(node, x))
            path.append(current_node)
        return path

    def initialize_matrix(self):
        if Path(self.FileName).is_file():
            with open(self.FileName, 'r') as f:
                lines = f.readlines()
                self.matrix = [list(map(lambda x: float('inf') if x == 'inf' else int(x), line.split())) for line in lines]
            return
        self.generate_matrix()
        with open(self.FileName, 'w') as f:
            for row in self.matrix:
                f.write(" ".join(map(str, row)) + "\n")

    def generate_matrix(self):
        self.matrix = [[0] * self.CityNumber for _ in range(self.CityNumber)]
        for i in range(self.CityNumber):
            for j in range(i + 1, self.CityNumber):
                self.matrix[i][j] = random.randint(5, 150)
                self.matrix[j][i] = self.matrix[i][j]
        for i in range(self.CityNumber):
            self.matrix[i][i] = float('inf')


class Solution:
    def __init__(self, problem, path):
        self.problem = problem
        self.path = path
        self.cost = problem.get_cost(path)

    def shuffle(self):
        random.shuffle(self.path)
        self.cost = self.problem.get_cost(self.path)
        return self

    def __lt__(self, other):
        return self.cost < other.cost


problem = Problem()
batch_number = 4
probability = 0.3
algorithm = GeneticAlgorithm(batch_number, probability, problem)
with open("result.txt", "w") as file:
    for i in range(500):
        for j in range(20):
            algorithm.iterate()

        line = f"{i * 20 + 20}  {algorithm.get_best_solution().cost}\n"
        print(line)

        file.write(line)

