extends CharacterBody2D
var all_worker :Array
var market
@export var move_speed : float = 1000
var time: float
var total_debt: int = 0
func _buy_wood():
		market = get_tree().get_first_node_in_group("WoodMarket")
		var buy_amount = 1000
		if market.goods_stock < buy_amount:
			return
		market.money += market.price * buy_amount
		market.goods_stock -= buy_amount 
		market.income += market.price * buy_amount
		market.sales += buy_amount
		
func _ready():
	%Button.pressed.connect(func stimulus():
		all_worker = get_tree().get_nodes_in_group("Worker")
		for worker in all_worker:
			worker.money += 100000
		)
	%Button2.pressed.connect(_buy_wood)
func _process(delta: float):
	time += delta
	#_buy_wood()
func _physics_process(_delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		
	).normalized()
	if input_direction == Vector2(1,1) or input_direction == Vector2(-1,-1) or input_direction == Vector2(-1,1) or input_direction == Vector2(1,-1) :
		velocity = input_direction * _delta
		
	else :
		velocity = input_direction * move_speed * _delta
	
	move_and_slide()
	
	
