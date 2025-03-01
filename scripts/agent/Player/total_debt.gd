extends Label

@export var player: Node2D
var all_unit: Array

func total_debt_calculate(unit_array):
	var total_debt: int = 0
	for unit in unit_array:
		total_debt += unit.debt
	return total_debt
func _ready():
	all_unit = get_tree().get_nodes_in_group("AllUnit")
	

func  _process(_delta: float):
	
	all_unit = get_tree().get_nodes_in_group("AllUnit")
	player.total_debt = total_debt_calculate(all_unit)
	self.text = str(total_debt_calculate(all_unit))
