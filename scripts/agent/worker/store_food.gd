extends State
class_name WorkerStoreFood
@export var worker: Node2D
var all_target: Array

func Enter():
	worker.house.food_reserve += worker.food
	worker.food -= worker.food
	

func Update(_delta: float):
	if  worker.food > 0 and worker.house.food_reserve < worker.house.food_reserve_limit:
		worker.house.food_reserve += worker.food
		worker.food -= worker.food
	Transitioned.emit(self, "Rest")
	

func Physics_Update(_delta: float):
	worker.velocity = Vector2(0,0) * 0
