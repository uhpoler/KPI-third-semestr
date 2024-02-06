import math
import time
import os


def combine_files(file_names): #зливає менші серії у більші
    num_of_files = len(file_names)
    current_series = []
    new_output_files = []
    file_list = []
    file_sizes = [0] * num_of_files
    new_file_indices = []
    current_new_file_index = 0
    remaining_files = num_of_files

    for i, name in enumerate(file_names):
        file_sizes[i] = os.path.getsize(file_names[i] + ".txt")
        new_output_files.append(open(str(int(name) + num_of_files) + ".txt", "w"))
        file_list.append(open(name + ".txt", "r"))
        symbol = file_list[i].readline()
        file_sizes[i] -= len(symbol) + 1
        if symbol != "" and symbol != "\n":
            current_series.append(int(symbol))
        else: #якщо файл пустий, потрібно зменшити загальну кількість
            file_sizes[i] = 0
            current_series.append(float('inf'))
            remaining_files -= 1


    while any(x > 1 for x in file_sizes):  #Поки не будуть оброблені всі числа у всіх файлах
        while remaining_files > 0:  #Поки хоча б один файл містить числа, пов'язані з поточною серією
            min_element = min(current_series)
            min_index = current_series.index(min_element)

            write_to_file(min_element, new_output_files[current_new_file_index % num_of_files])
            current_series.pop(min_index)
            symbol = file_list[min_index].readline()
            file_sizes[min_index] -= len(symbol) + 1
            if symbol != "\n" and symbol != "":
                current_series.insert(min_index, int(symbol))
            else:
                current_series.insert(min_index, float('inf'))
                remaining_files -= 1
        write_to_file(None, new_output_files[current_new_file_index % num_of_files], True)
        current_new_file_index += 1
        current_series.clear()
        remaining_files = num_of_files

        for i in range(num_of_files):
            symbol = file_list[i].readline()
            file_sizes[i] -= len(symbol) + 1
            if symbol != "\n" and symbol != "":
                current_series.append(int(symbol))
            else:
                file_sizes[i] = 0
                current_series.append(float('inf'))
                remaining_files -= 1
    for file in new_output_files:
        file.close()

    for i, file in enumerate(file_list):
        if current_new_file_index - 1 >= i: #якщо поточний файл використаний для об'єднання в результуючий файл
            new_file_indices.append(str(int(file.name[:-4]) + num_of_files)) #ім'я поточного файлу змінюється
        file.close()
        os.remove(file.name)
    if len(new_file_indices) < num_of_files:
        for i in range(num_of_files - len(new_file_indices)):
            os.remove(str(int(new_file_indices[-1]) + i + 1) + ".txt")
    return new_file_indices



def write_to_file(series_list, file_list, space=0):
    line= ""
    if space:
        file_list.write("\n")
        return
    if type(series_list) == list:
        for i in series_list:
            line += str(i) + "\n"
        file_list.write(line + "\n")
    else:
        file_list.write(str(series_list) + "\n")




#Pозділення вихідного файлу на серії та запис їх у нові файли
def split_input_file(input_file, n_files):
    series_list = []
    file_list = []

    for file in range(n_files):
        file_list.append(open(str(file) + ".txt", "w")) #створюються та відкриваються файли для запису

    current_i = 0
    current_f = 0
    with open(input_file, "r") as file:
        for line in file:
            if current_i != 0 and series_list[current_i - 1] >= int(line):
                write_to_file(series_list, file_list[current_f % n_files])
                current_f += 1
                current_i = 0
                series_list.clear()
            current_i += 1
            series_list.append(int(line))
        write_to_file(series_list, file_list[current_f % n_files])
    for file in file_list:
        file.close()




input_file = "input_10.txt"

n_files = 8 + int(math.log2(os.path.getsize(input_file) / 1000000))#визначення розміру файлу в байтах, переторення на мб К-сть допоміжних файлів



split_input_file(input_file, n_files)

print("Початок збалансованого багатошляхового злиття")
t1 = time.time()

file_names = combine_files([str(i) for i in range(n_files)])

while len(file_names) > 1:
    file_names = combine_files(file_names)

if os.path.exists("output.txt"):
    os.remove("output.txt")

os.rename(str(file_names[0]) + ".txt", "output.txt")

t2 = time.time()
print("Час в секундах : ",str(round((t2-t1),2)))
print("Час в хвилинах : ", str(round(((t2-t1)/60),1)))

