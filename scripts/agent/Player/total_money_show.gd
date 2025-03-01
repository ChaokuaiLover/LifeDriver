extends Label
var all_unit: Array
@export var player: Node2D
func total_money_supplies_calculate(unit_array):
	var total_money: int = 0
	for unit in unit_array:
		total_money += int(unit.money)
	return total_money
func _ready():
	all_unit = get_tree().get_nodes_in_group("AllUnit")
	

func  _process(_delta: float):
	all_unit = get_tree().get_nodes_in_group("AllUnit")
	self.text = str(total_money_supplies_calculate(all_unit))
