import random

print('Генерація файлу на 10 мб....')

with open('input_10.txt', 'w') as file:
    file_size = 0
    while file_size < 10953132:
        number = random.randint(0, 99999)
        file.write(str(number) + '\n')
        file_size = file.tell()


print('Файл на 10 мб створено.')

