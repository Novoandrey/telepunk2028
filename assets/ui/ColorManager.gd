extends Node

class_name ColorManager  # For reference in other scripts

# Токены цветов
var view = Color.from_ok_hsl(0, 0, 0.3) # Блок контента
var navigation = Color.from_ok_hsl(0, 0, 0.2) # Блок навигации

var border = Color.from_ok_hsl(0, 0, 0.6) # Линейки разделители для двух блоков
var overlay = Color.from_ok_hsl(0, 0, 0, 0.8) # Затемнение заблокированного содержимого

var background = Color.from_ok_hsl(0.1, 0.6, 0.8) # Основной цвет фона элемента (фон secondary кнопки)
var primary = Color.from_ok_hsl(0.05, 0.05, 0.05) # Основной цвет элемента, тексты
var secondary = Color.from_ok_hsl(1, 1, 1) # Второстепенный цвет элемента, менее важнные тексты
var disabled = Color.from_ok_hsl(1, 1, 1) # Неактивный (текст или иконка diabled кнопки)
var accent = Color.from_ok_hsl(1, 1, 1) # Акцентный цвет элемента (фон primary кнопки)
var on_accent = Color.from_ok_hsl(1, 1, 1) # Цвет, который виден поверх акцента (текст или иконка primary кнопки)

var danger = Color.from_ok_hsl(0.04, 1, 0.6) # Опасность
var success = Color.from_ok_hsl(0.35, 1, 1) # Успех
var warning = Color.from_ok_hsl(0.35, 1, 0.5) # Предупреждение
