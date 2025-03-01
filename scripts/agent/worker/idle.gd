extends State
class_name WorkerIdle
@export var worker: Node2D
var wander_time : float
var direction: Vector2

func randomize_wander():
	direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)
func Enter():
	randomize_wander()
	pass

func Update(delta: float):
	wander_time -= delta
	if wander_time <= 0:
		randomize_wander()
		worker.velocity = direction.normalized() * worker.move_speed * delta
		
	elif worker.energy <= 90 and worker.food > 0:
		Transitioned.emit(self, "Rest")
	
	elif  worker.energy > 90 :
		Transitioned.emit(self, "Work")
	

func Physics_Update(_delta: float):
	pass
