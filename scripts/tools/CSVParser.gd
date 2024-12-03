class_name CSVParser extends Node

const HEADERS = "headers"
const VALUES = "values"

static func read_csv(file_path): ##Чтение csv файла. Возвращает словарь с заголовками таблицы, id ввиде 1 столбца таблицы и информацией об каждой строке по id
	var res = FileAccess.open(file_path, FileAccess.READ)
	var res_dict = {}
	var line_count = -1
	while !res.eof_reached():
		var cur_line = res.get_csv_line()
		if line_count == -1:
			res_dict[HEADERS] = cur_line
			res_dict[cur_line[0]] = []
		else:
			var index = 0
			res_dict[cur_line[0]] = {}
			for head in res_dict.get(HEADERS):
				if index == 0:
					res_dict[head].append(cur_line[0])
				res_dict[cur_line[0]][head] = cur_line[index]
				index += 1
		line_count += 1
	for key in res_dict.keys():
		print(key)
	print(res_dict.get('def'))
	return res_dict

# TODO: Добавить обновление синапсов
static func update_values():
	pass
