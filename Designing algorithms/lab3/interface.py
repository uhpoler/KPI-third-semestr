
import tkinter as tk
import tkinter.filedialog
import tkinter.messagebox
from rbtree import RedBlackTree


class Window1:
    #Вікно з функціями додавання, пошуку, видалення та зміни запису
    def __init__(self, master):
        self.master = master
        self.master.title("СУБД")
        self.master.geometry("300x200")
        self.master.resizable(width=False, height=False)
        self.master.iconbitmap("logo.ico")
        self.Tree = None
        self.Tree = RedBlackTree()
        filepath="D:\programming\Java\pa-skrypets-olh\src\lab3\database.txt"

        self.app = None
        try:
            self.Tree = RedBlackTree.read_tree_from_file(self.Tree, filepath)
            self.root = None
            self.root = self.Tree.get_root()
            self.filepath = filepath

            self.master.title("СУБД")
            self.master.geometry("595x370")
            self.master.resizable(width=False, height=False)
            self.master.iconbitmap("logo.ico")
            self.master.configure(bg="#FFC0CB")

            self.label = tk.Label(self.master,text="Оберіть дію:", background="#FFC0CB", height=2, font=("Arial, 15"))
            self.label.pack(pady=5)
            self.button3 = tk.Button(self.master, text="Додати запис", font=("Arial, 10"), width=30, height=4, background="#FF69B4", command=self.insert_record)
            self.button3.place(x=15, y=70)
            self.button2 = tk.Button(self.master, text="Знайти запис", font=("Arial, 10"), width=30, height=4, background="#FF69B4", command=self.search_record)
            self.button2.place(x=320, y=70)
            self.button4 = tk.Button(self.master, text="Видалити запис", font=("Arial, 10"), width=30, height=4, background="#FF69B4", command=self.delete_record)
            self.button4.place(x=15, y=170)
            self.button5 = tk.Button(self.master, text="Змінити запис", font=("Arial, 10"), width=30, height=4, background="#FF69B4", command=self.change_record)
            self.button5.place(x=320, y=170)
            self.button6 = tk.Button(self.master, text="Зберегти", font=("Arial, 10"), width=68, height=4, background="#FF69B4", command=self.save_DB)
            self.button6.place(x=13, y=270)

            self.master.protocol("WM_DELETE_WINDOW", self.close_window)
        except ValueError:
            tkinter.messagebox.showerror(title="СУБД", message="Помилка при зчитуванні файлу!")
        return

    def close_window(self):
        if self.app:
            self.Tree, self.root = self.app.get_tree_root()
        is_save = True
        if tkinter.messagebox.askyesno(title="СУБД", message="Зберегти базу даних?"):
            is_save = self.save_DB()
        if is_save:
            self.master.destroy()
        return

    def save_DB(self):
        is_save = True
        self.root = self.Tree.get_root()
        tkinter.messagebox.showinfo(title="Збереження файлу", message="Файл успішно збережений!")
        if self.filepath:
            self.Tree.write_data(self.filepath)
        else:
            self.filepath = tk.filedialog.asksaveasfile(title="Зберегти базу даних", initialdir="D:\programming\lab3_pa", initialfile = "Untitled.txt", defaultextension=".txt", filetypes=[("Бази даних","*.txt")])
            if not self.filepath:
                tkinter.messagebox.showerror(title="СУБД", message="Файл не вибрано!")
                is_save = False
                tkinter.messagebox.showinfo(title="Збереження файлу", message="Файл успішно збережений!")
            else:
                self.filepath = self.filepath.name
                self.Tree.write_data(self.root, self.filepath)
        return is_save

    def search_record(self):
        #Пошук даних за ключем
        if self.app:
            self.Tree, self.root = self.app.get_tree_root()
        self.master.withdraw()
        self.newWindow = tk.Toplevel(self.master)
        self.app = Search_record(self.newWindow, self.master, self.Tree, self.root)
        return

    def insert_record(self):
        #Додавання даних за ключем
        if self.app:
            self.Tree, self.root = self.app.get_tree_root()
        self.master.withdraw()
        self.newWindow = tk.Toplevel(self.master)
        self.app = Insert_record(self.newWindow, self.master, self.Tree, self.root)
        return

    def delete_record(self):
        #Видалення даних за ключем
        if self.app:
            self.Tree, self.root = self.app.get_tree_root()
        self.master.withdraw()
        self.newWindow = tk.Toplevel(self.master)
        self.app = Delete_record(self.newWindow, self.master, self.Tree, self.root)
        return

    def change_record(self):
        #Зміна даних за ключем
        if self.app:
            self.Tree, self.root = self.app.get_tree_root()
        self.master.withdraw()
        self.newWindow = tk.Toplevel(self.master)
        self.app = Change_record(self.newWindow, self.master, self.Tree, self.root)
        return

class Search_record():
    def __init__(self, master, previous_window, Tree, root):
        self.previous_window = previous_window
        self.Tree = Tree
        self.root = root

        self.master = master
        self.master.title("Знайти запис")
        self.master.geometry("300x105")
        self.master.resizable(width=False, height=False)
        self.master.iconbitmap("logo.ico")
        self.master.configure(bg="#FFC0CB")

        self.label = tk.Label(self.master, text="Введіть ключ:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label.place(x=15, y=15)
        self.entry = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry.place(x=155, y=15)
        self.button1 = tk.Button(self.master, text="Знайти запис", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.search_record)
        self.button1.place(x=13, y=50)
        self.button2 = tk.Button(self.master, text="Назад", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.exit)
        self.button2.place(x=155, y=50)

        self.master.protocol("WM_DELETE_WINDOW", self.exit)
        return

    def search_record(self):
        if not self.entry.get():
            tkinter.messagebox.showerror(title="Знайти запис", message="Ключ не введений!")
        else:
            try:
                key = int(self.entry.get())
                data = self.Tree.searchTree(key).data
                message = ("Запис знайдено!\nКлюч: " + str(key) + "\nДані: " + str(data)) if data else "Даних за ключем " + str(key) + " не знайдено!"
                tkinter.messagebox.showinfo(title="Знайти запис", message=message)

                print(f"Число порівнянь для знаходження запису за ключем {key} = {self.Tree.number_comparison}")
                self.Tree.number_comparison = 0
            except ValueError:
                tkinter.messagebox.showerror(title="Знайти запис", message="Ключ повинен бути цілим числом!")
        return

    def exit(self):
        self.previous_window.deiconify()
        self.master.destroy()
        return

    def get_tree_root(self):
        return self.Tree, self.root

class Insert_record():
    def __init__(self, master, previous_window, Tree, root):
        self.previous_window = previous_window
        self.Tree = Tree
        self.root = root

        self.master = master
        self.master.title("Додати запис")
        self.master.geometry("300x140")
        self.master.resizable(width=False, height=False)
        self.master.iconbitmap("logo.ico")
        self.master.configure(bg="#FFC0CB")

        self.label1 = tk.Label(self.master, text="Введіть ключ:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label1.place(x=15, y=15)
        self.entry1 = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry1.place(x=155, y=15)
        self.label2 = tk.Label(self.master, text="Введіть дані:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label2.place(x=15, y=50)
        self.entry2 = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry2.place(x=155, y=50)
        self.button1 = tk.Button(self.master, text="Вставити запис", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.insert_record)
        self.button1.place(x=13, y=85)
        self.button2 = tk.Button(self.master, text="Назад", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.exit)
        self.button2.place(x=155, y=85)

        self.master.protocol("WM_DELETE_WINDOW", self.exit)
        return

    def insert_record(self):
        if not self.entry1.get():
            tkinter.messagebox.showerror(title="Вставити запис", message="Ключ не введений!")
        elif not self.entry2.get():
            tkinter.messagebox.showerror(title="Вставити запис", message="Дані не введені!")
        else:
            try:
                key = int(self.entry1.get())
                data = self.entry2.get()
                node, is_insert = self.Tree.insert(key, data)
                message = ("Запис вставлено!\nКлюч: " + str(key) + "\nДані: " + str(data)) if is_insert else "Ключ " + str(key) + " вже є у базі даних!"
                tkinter.messagebox.showinfo(title="Вставити запис", message=message)
            except ValueError:
                tkinter.messagebox.showerror(title="Вставити запис", message="Ключ повинен бути цілим числом!")
        return

    def exit(self):
        self.previous_window.deiconify()
        self.master.destroy()
        return

    def get_tree_root(self):
        return self.Tree, self.root

class Delete_record():
    def __init__(self, master, previous_window, Tree, root):
        self.previous_window = previous_window
        self.Tree = Tree
        self.root = root

        self.master = master
        self.master.title("Видалити запис")
        self.master.geometry("300x105")
        self.master.resizable(width=False, height=False)
        self.master.iconbitmap("logo.ico")
        self.master.configure(bg="#FFC0CB")

        self.label = tk.Label(self.master, text="Введіть ключ:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label.place(x=15, y=15)
        self.entry = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry.place(x=155, y=15)
        self.button1 = tk.Button(self.master, text="Видалити запис", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.delete_record)
        self.button1.place(x=13, y=50)
        self.button2 = tk.Button(self.master, text="Назад", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.exit)
        self.button2.place(x=155, y=50)

        self.master.protocol("WM_DELETE_WINDOW", self.exit)
        return

    def delete_record(self):
        if not self.entry.get():
            tkinter.messagebox.showerror(title="Видалення запису", message="Ключ не введений!")
        else:
            try:
                key = int(self.entry.get())
                data = self.Tree.delete_node(key)
                message = ("Запис видалено!\nКлюч: " + str(key) + "\nДані: " + str(data)) if data else "Даних за ключем " + str(key) + " немає!"
                tkinter.messagebox.showinfo(title="Видалення запису", message=message)
            except ValueError:
                tkinter.messagebox.showerror(title="Видалення запису", message="Ключ повинен бути цілим числом!")
        return

    def exit(self):
        self.previous_window.deiconify()
        self.master.destroy()
        return

    def get_tree_root(self):
        return self.Tree, self.root

class Change_record():
    def __init__(self, master, previous_window, Tree, root):
        self.previous_window = previous_window
        self.Tree = Tree
        self.root = root

        self.master = master
        self.master.title("Змінити запис")
        self.master.geometry("300x140")
        self.master.resizable(width=False, height=False)
        self.master.iconbitmap("logo.ico")
        self.master.configure(bg="#FFC0CB")

        self.label1 = tk.Label(self.master, text="Введіть ключ:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label1.place(x=15, y=15)
        self.entry1 = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry1.place(x=155, y=15)
        self.label2 = tk.Label(self.master, text="Введіть нові дані:", background="#FFC0CB", height=1, width=15, font=("Arial, 10"), justify=tk.CENTER)
        self.label2.place(x=15, y=50)
        self.entry2 = tk.Entry(self.master, font=("Arial, 10"), justify=tk.CENTER, width=18)
        self.entry2.place(x=155, y=50)
        self.button1 = tk.Button(self.master, text="Змінити запис", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.change_record)
        self.button1.place(x=13, y=85)
        self.button2 = tk.Button(self.master, text="Назад", font=("Arial, 10"), width=15, height=2, background="#FF69B4", command=self.exit)
        self.button2.place(x=155, y=85)

        self.master.protocol("WM_DELETE_WINDOW", self.exit)
        return

    def change_record(self):
        if not self.entry1.get():
            tkinter.messagebox.showerror(title="Змінити запис", message="Ключ не введений!")
        elif not self.entry2.get():
            tkinter.messagebox.showerror(title="Змінити запис", message="Нові дані не введені!")
        else:
            try:
                key = int(self.entry1.get())
                new_data = self.entry2.get()
                is_change = self.Tree.update_node_data(key, new_data)
                message = ("Запис змінено!\nКлюч: " + str(key) + "\nНові дані: " + str(new_data)) if is_change else "Ключа " + str(key) + " немає в базі даних!"
                tkinter.messagebox.showinfo(title="Змінити запис", message=message)
            except ValueError:
                tkinter.messagebox.showerror(title="Змінити запис", message="Ключ повинен бути цілим числом!")
        return

    def exit(self):
        self.previous_window.deiconify()
        self.master.destroy()
        return

    def get_tree_root(self):
        return self.Tree, self.root

def main():
    window = tk.Tk()
    app = Window1(window)
    window.mainloop()
    return

if __name__ == "__main__":
    main()
