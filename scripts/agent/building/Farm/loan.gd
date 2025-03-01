extends State
class_name FarmLoan
@export var farm: Node2D
var target
var all_target: Array
var direction
func Enter():
	all_target = get_tree().get_nodes_in_group("Bank")
	
func Update(_delta: float):
	
	pass

func Physics_Update(_delta: float):
	pass
