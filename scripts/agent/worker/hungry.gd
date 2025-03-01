extends State
class_name WorkerHungry
@export var worker: Node2D
var all_target: Array
var direction: Vector2
var target: Node2D
var need_energy: int

func Enter():
	
	need_energy = 100 - worker.passive_energy
	if worker.house.food_reserve >= need_energy:
		worker.passive_energy += need_energy
		worker.house.food_reserve -= need_energy
		
func Update(_delta: float):
	need_energy = 100 - worker.passive_energy
	if worker.house.food_reserve >= need_energy:
		worker.passive_energy += need_energy
		worker.house.food_reserve -= need_energy
	Transitioned.emit(self, "Rest")
func Physics_Update(_delta: float):
	worker.velocity = Vector2(0,0) * 0
