import random
import string

# Генерує унікальне ціле число та рядок букв
def generate_record(index):
    number = index
    data = ''.join(random.choice(string.ascii_letters) for _ in range(random.randint(5, 15)))
    return f"{number} {data}"

# Генерує файл з 10000 записами
def generate_file():
    with open("database.txt", "w") as file:
        for i in range(1, 10001):
            record = generate_record(i)
            file.write(record + "\n")

# Викликає функцію для генерації файлу
generate_file()