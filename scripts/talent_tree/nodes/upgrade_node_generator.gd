class_name GeneratorNode extends SynapsNode

# Сигнал генерации ресурса
signal resource_generated(resource_name, amount)

# Экспортируемая переменная для типа ресурса, который генерируется узлом
@export var resource_name_generated: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Таймер для генерации ресурса
var generator_timer: Timer
# Сумма ресурса, которая была произведена, но еще не использована
var resource_made: float
