import math
import time
import os



#Злиття менших серій у більші
def combine_files(file_names):
    num_of_files = len(file_names)
    current_series = []
    file_handler = []
    remaining_files = num_of_files

    output_file = open("output_modif.txt", "w")
    for i, name in enumerate(file_names):
        file_handler.append(open(name + ".txt", "r"))
        symbol = file_handler[i].readline()
        if symbol != "\n" and symbol != "":
            current_series.append(int(symbol))
        else:
            current_series.append(float('inf'))
            remaining_files -= 1
    while remaining_files > 0:
        min_element = min(current_series)
        min_index = current_series.index(min_element)
        write_to_file(min_element, output_file)
        current_series.pop(min_index)
        symbol = file_handler[min_index].readline()
        if symbol != "\n" and symbol != "":
            current_series.insert(min_index, int(symbol))
        else:
            current_series.insert(min_index, float('inf'))
            remaining_files -= 1
    write_to_file(None, output_file, True)
    current_series.clear()
    remaining_files = num_of_files

    for i in range(num_of_files):
        symbol = file_handler[i].readline()
        if symbol != "\n" and symbol != "":
            current_series.append(int(symbol))
        else:
            current_series.append(float('inf'))
            remaining_files -= 1
    output_file.close()
    for file in file_handler:
        file.close()
        os.remove(file.name)



def write_to_file(series_list, file_number, space=0):
    line= ""
    if space:
        file_number.write("\n")
        return
    if type(series_list) == list:
        for i in series_list:
            line += str(i) + "\n"
        file_number.write(line + "\n")
    else:
        file_number.write(str(series_list) + "\n")



#Pозділення вихідного файлу на серії та запис їх у нові файли
def split_input_file(input_file, size):
    with open(input_file, "r") as file:
        num_line = 0
        num_file = 0
        series_list = []

        line = file.readline()
        while line != "":
            series_list.append(int(line))
            num_line += 1
            line = file.readline()
            if num_line == size:
                with open(f"{num_file}.txt", "w") as file_number:
                    series_list.sort() #сотуються елементи в кожній серії
                    write_to_file(series_list, file_number)
                    num_file += 1
                    series_list.clear()
                    num_line = 0
    return [f"{i}" for i in range(num_file)]

def count_lines(filename):
    try:
        with open(filename, 'r') as file:
            line_count = sum(1 for line in file)
        return line_count
    except FileNotFoundError:
        print(f"Файл '{filename}' не знайдено.")
        return None


print("Початок роботи програми")

input_file="input_10.txt"
line_count = count_lines(input_file)

if(input_file=="input_10.txt"):
    size=int(line_count/6)

if(input_file=="input_100.txt"):
    size = int(line_count/21)

if(input_file=="input_1000.txt"):
    size = int(line_count/30)


# файл10   ліній 1589982 ділю на 6=264997
# файл100  ліній 14516267 ділю на 21=691251 (від 19 до 25 один ефект)
# файл1000 ліній 244534210 ділю на 30=8151140  якщо на 18  13585234

print("Початок збалансованого багатошляхового злиття")
print("Версія з модифікацією")
t1 = time.time()

file_names = split_input_file(input_file, size)
combine_files(file_names)


t2 = time.time()
print("Час в секундах : ",str(round((t2-t1),2)))
print("Час в хвилинах : ", str(round(((t2-t1)/60),1)))
