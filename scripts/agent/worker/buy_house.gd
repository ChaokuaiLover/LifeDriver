extends State
class_name WorkerBuyHouse
@export var worker: CharacterBody2D
var target: Node2D
var all_target: Array
var direction: Vector2

func Enter():
	worker.energy_drain_index = 0.1
	all_target = get_tree().get_nodes_in_group("House")
	target = Function.find_best_length_target_buy(worker,all_target)
	
func  Exit():
	worker.energy_drain_index = 1.0
func Update(_delta: float):
	all_target = get_tree().get_nodes_in_group("House")
	target = Function.find_best_length_target_buy(worker,all_target)
	if worker.house != null:
		if worker.house.house_owner == worker:
			Transitioned.emit(self,"Work")
			
func Physics_Update(delta: float):
	if target:
		worker.current_target = target
		direction = target.global_position - worker.global_position
		worker.velocity = direction.normalized() * worker.move_speed * delta
		
	if worker.energy <= 30:
		worker.queue_free()
	#elif worker.money <= worker.food_price * worker.food_need:
		#Transitioned.emit(self, "Loan")
