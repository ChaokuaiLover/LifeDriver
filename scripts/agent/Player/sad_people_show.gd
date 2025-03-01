extends Label
var all_unit: Array
func sad_people_amount(unit_array):
	var amount: int = 0
	for unit in unit_array:
		if unit.mood == "sad":
			amount += 1
	return amount
func _ready():
	self.text = str(0)
	all_unit = get_tree().get_nodes_in_group("Worker")
	

func  _process(_delta: float):
	all_unit = get_tree().get_nodes_in_group("Worker")
	self.text = str(sad_people_amount(all_unit))
