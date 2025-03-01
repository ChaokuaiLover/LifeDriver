extends State
class_name WorkerGoToHouse
@export var worker: Node2D
var target: Node2D
var all_target: Array
var direction: Vector2

func Enter():
	target = worker.house

func Update(_delta: float):
	if worker.inside_house and worker.money >= int(worker.debt * 2.0):
		Transitioned.emit(self, "PayLoan")
	elif worker.inside_house:
		Transitioned.emit(self, "StoreFood")
	
	
func Physics_Update(delta: float):
	if target != null :
		worker.current_target = target
		direction = target.global_position - worker.global_position
		worker.velocity = direction.normalized() * worker.move_speed * delta
		
	
