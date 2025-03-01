extends Sprite2D
class_name Shipping
var money: int = 100000000
var debt: int = 0
var emlployee_list
func _ready():
	$Area2D.body_entered.connect(func first_time(body: Node2D):
		pass
		)
	
	$Area2D.body_entered.connect(func rest(body: Node2D):
		pass
		)
	

func _process(_delta: float):
	pass
