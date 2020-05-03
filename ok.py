filename = input("Name of txt file: ")

arr = "// " + filename + "\n" + filename + " = {"
infile = open("./sprite_bytes/" + filename + ".txt", "r")
outfile = open("./sprite_bytes/block_sprites.sv", "a+")
data = infile.readlines()
dico = {'0': '0', '1': '1', '2': '2', '3': '3', '4': '4', '5': '5', '6': '6', '7': '7',
        '8': '8', '9': '9', 'a': '10', 'b': '11', 'c': '12', 'd': '13', 'e': '14',
        'f': '15', '10': '16', '11': '17', '12': '18', '13': '19', '14': '20', '15': '21',
        '16': '22', '17': '23', '18': '24', '19': '25', '1a': '26', '1b': '27', '1c', '28',
        '1d': '29'}
for j in range(20):
    for i in range(20):
        addstr = dico[data[j*20+i].strip("\n")] + ", "
        arr += addstr
    arr += "\n"
arr += "}\n"
outfile.write(arr)
outfile.close()
infile.close()
print("Finished making sv array")
