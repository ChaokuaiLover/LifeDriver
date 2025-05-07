extends State
class_name WorkerWork
@export var worker: Node2D
var target: Node2D
var all_target: Array
var direction: Vector2


func Enter():
	target = worker.work_target
	worker.work_state = "going"

func Update(_delta: float):
	target = worker.work_target
		
	if  (worker.work_state == "success" or worker.work_state == "fail" or target == null) and !worker.inside_house:
		Transitioned.emit(self, "GoToHouse")
	elif (worker.work_state == "success" or worker.work_state == "fail" or target == null) and worker.inside_house:
		Transitioned.emit(self, "Rest")
	
func Physics_Update(delta: float):
	if target != null and worker.work_state == "going":
		worker.current_target = target
		direction = target.global_position - worker.global_position
		worker.velocity = direction.normalized() * worker.move_speed * delta
		
	else:
		worker.velocity = Vector2(0,0) * 0
	
