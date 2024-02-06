import matplotlib.pyplot as plt
import numpy as np
import random
from queue import Queue
from queue import PriorityQueue

def create_maze(dim):
    maze = np.ones((dim, dim))
    x, y = (0, 0)

    maze[x, y] = 0
    stack = [(x, y)]
    while len(stack) > 0:
        x, y = stack[-1]

        directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        random.shuffle(directions)

        path_available = False
        for dx, dy in directions:
            nx, ny = x + 2 * dx, y + 2 * dy
            if 0 <= nx < dim and 0 <= ny < dim and maze[nx, ny] == 1:
                maze[nx, ny] = 0
                maze[x + dx, y + dy] = 0
                stack.append((nx, ny))
                path_available = True
                break

        if not path_available:
            stack.pop()

    maze[dim - 2, dim - 1] = 0  # Початок
    maze[1, 0] = 0  # Кінець
    return maze


def h(cell, goal):
    x1, y1 = cell
    x2, y2 = goal
    return ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5


def reconstruct_path(aPath, current):
    total_path = [current]
    while current in aPath:
        current = aPath[current]
        total_path.insert(0, current)
    return total_path


def aStar(maze, start, goal, closed_set=None):
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    open = PriorityQueue()
    open.put((0, start))
    aPath = {}
    g_score = np.full(maze.shape, float("inf"))
    g_score[start] = 0
    f_score = np.full(maze.shape, float("inf"))
    f_score[start] = h(start, goal)

    states = 0
    iterations = 0
    dead_ends = 0
    visited_states = set()
    while not open.empty():
        states = max(states, len(open.queue))
        iterations += 1
        current = open.get()[1]
        visited_states.add(current)

        if current == goal:
            iterations += 1
            return reconstruct_path(aPath, current), states, iterations, dead_ends, len(visited_states)

        if closed_set is not None:
            iterations += 1
            closed_set.add(current)

            neighbors = [(current[0] + dx, current[1] + dy) for dx, dy in directions]
            valid_neighbors = [
                neighbor
                for neighbor in neighbors
                    if (
                            0 <= neighbor[0] < maze.shape[0]
                            and 0 <= neighbor[1] < maze.shape[1]
                            and maze[neighbor] == 0
                    )
                ]

        if len(valid_neighbors) == 1:  # If there is only one valid neighbor, it's a dead end
            if current[0] != maze2.shape[0] - 2 or current[1] != maze2.shape[1] - 1:
                if current[0] != maze2.shape[0] - 2 or current[1] != maze2.shape[1] - 2:
                    dead_ends += 1

        for next_cell in valid_neighbors:
            iterations += 1
            if next_cell not in visited_states:  # Check if the neighbor has been visited
                tentative_g_score = g_score[current] + 1
                if tentative_g_score < g_score[next_cell]:
                    aPath[next_cell] = current
                    g_score[next_cell] = tentative_g_score
                    f_score[next_cell] = tentative_g_score + h(next_cell, goal)
                    open.put((f_score[next_cell], next_cell))

    return None, states, iterations, dead_ends, len(visited_states)



def bfs(maze):
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    start = (maze.shape[0] - 1, maze.shape[1] - 1)
    end = (1, 0)
    visited = np.zeros_like(maze, dtype=bool)
    visited[start] = True
    queue = Queue()
    queue.put((start, []))

    iterations = 0
    dead_ends = 0
    states = 0
    visited_states = set()

    while not queue.empty():
        states = max(states, len(queue.queue))
        iterations += 1
        (node, path) = queue.get()
        visited_states.add(node)

        neighbors = [
            (node[0] + dx, node[1] + dy) for dx, dy in directions
        ]
        valid_neighbors = [
            neighbor
            for neighbor in neighbors
            if (
                    0 <= neighbor[0] < maze.shape[0]
                    and 0 <= neighbor[1] < maze.shape[1]
                    and maze[neighbor] == 0
            )
        ]

        if len(valid_neighbors) == 1 and len(path) > 1:
            dead_ends += 1

        for next_node in valid_neighbors:
            iterations += 1
            if next_node == end:
                return path + [next_node], states, iterations, dead_ends, len(visited_states)
            if (
                    next_node[0] >= 0
                    and next_node[1] >= 0
                    and next_node[0] < maze.shape[0]
                    and next_node[1] < maze.shape[1]
                    and maze[next_node] == 0
                    and not visited[next_node]
            ):
                visited[next_node] = True
                queue.put((next_node, path + [next_node]))

    return None, states, iterations, dead_ends - 1, len(visited_states)


def visualize_bfs(maze, path=None, algorithm_name="Algorithm"):
    fig, ax = plt.subplots(figsize=(10, 10))

    fig.patch.set_edgecolor('white')
    fig.patch.set_linewidth(0)

    ax.imshow(maze, cmap=plt.cm.binary, interpolation='nearest')

    if path is not None:
        x_coords = [x[1] for x in path]
        y_coords = [y[0] for y in path]
        ax.plot(x_coords, y_coords, color='red', linewidth=3)

    ax.set_xticks([])
    ax.set_yticks([])

    start_x, start_y = maze.shape[1] - 1, maze.shape[0] - 2
    end_x, end_y = 0, 1

    ax.plot(start_x, start_y, 'o', markersize=10, color='blue')  # Кругла крапка для початку
    ax.plot(end_x, end_y, 'x', markersize=20, color='red')  # Хрестик для кінця

    plt.title(algorithm_name)
    plt.show()


def visualize_astar(maze, path=None, closed_set=None, algorithm_name="Algorithm"):
    fig, ax = plt.subplots(figsize=(10, 10))
    fig.patch.set_edgecolor('white')
    fig.patch.set_linewidth(0)
    ax.imshow(maze, cmap=plt.cm.binary, interpolation='nearest')

    if path:
        x_coords = [x[1] for x in path]
        y_coords = [y[0] for y in path]
        ax.plot(x_coords, y_coords, color='blue', linewidth=3)

    if closed_set is not None:
        # Позначення проглянутих клітинок жовтим кубиком
        for cell in closed_set:
            x, y = cell
            ax.add_patch(plt.Rectangle((y - 0.4, x - 0.4), 0.8, 0.8, color='yellow'))

    ax.set_xticks([])
    ax.set_yticks([])
    ax.plot(start[1], start[0], 'o', markersize=10, color='blue')
    ax.plot(end[1], end[0], 'x', markersize=20, color='red')

    plt.title(algorithm_name)
    plt.show()

while True:
    try:
        dim = int(input("Enter the dimension of the maze: "))
        if 3 <= dim <= 100:
            break
        else:
            print("Please enter a value within the range of 3 to 100.")
    except ValueError:
        print("Please enter a valid number.")

maze1 = create_maze(dim)
maze2 = np.copy(maze1)

start = (maze2.shape[0] - 2, maze2.shape[1] - 1)
end = (1, 0)

closed_set = set()

path_bfs, states_bfs, iterations_bfs, dead_ends_bfs, total_states_bfs = bfs(maze1)
path_astar, states_astar, iterations_astar, dead_ends_astar, total_states_astar = aStar(maze2, start, end, closed_set)

print("BFS states:", states_bfs)
print("BFS dead ends:", dead_ends_bfs)
print("BFS iterations:", iterations_bfs)
print("BFS total states:", total_states_bfs)


print("A* states:", states_astar)
print("A* dead ends:", dead_ends_astar)
print("A* iterations:", iterations_astar)
print("A* total states:", total_states_astar)

visualize_bfs(maze1, path_bfs, "BFS")
visualize_astar(maze2, path_astar, closed_set, "A*")
