extends Label
var all_unit: Array

func price_average_calculate(unit_array):
	var total_wage: int = 0
	var wage_average: int
	for unit in unit_array:
		if unit.wage_offer:
			total_wage += unit.wage_offer
	wage_average = int(float(total_wage) / unit_array.size())
	return wage_average
func _ready():
	all_unit = get_tree().get_nodes_in_group("WorkBuilding")
	

func  _process(_delta: float):
	all_unit = get_tree().get_nodes_in_group("WorkBuilding")
	self.text = str(price_average_calculate(all_unit))
