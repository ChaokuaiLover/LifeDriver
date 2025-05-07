extends State
class_name WorkerBuyFood
@export var worker: CharacterBody2D
var target: Node2D
var all_target: Array
var direction: Vector2
var conditions: bool
func Enter():
	target = worker.food_market
	worker.buy_food_state = "going"
	all_target = get_tree().get_nodes_in_group("FoodMarket")
	target = Function.find_best_target_buy(worker.house,all_target,worker.speed_pixel_per_second,worker.time_value)
	
func Update(_delta: float):
	target = worker.food_market
	conditions = worker.buy_food_state == "success" or worker.buy_food_state == "fail" or worker.money < worker.food_price * worker.food_need or target == null or !target.sell_status
	if conditions and !worker.inside_house:
		Transitioned.emit(self, "GoToHouse")
	elif conditions and worker.inside_house:
		Transitioned.emit(self, "Rest")
		
		
	#elif worker.money <= worker.food_price * worker.food_need:
		#Transitioned.emit(self, "Loan")

func Physics_Update(delta: float):
	if target and worker.buy_food_state == "going":
		worker.current_target = target
		direction = target.global_position - worker.global_position
		worker.velocity = direction.normalized() * worker.move_speed * delta
	else:
		worker.velocity = Vector2(0,0) * 0
