extends CharacterBody2D
class_name Worker
var move_speed: float = 1800.0
var speed_pixel_per_second: float = move_speed/ 30.0  #pixel per second
var energy: float
var energy_start : float = 100.0
var energy_drain_index: float = 1.0
var hungry_time: float = 100.0 #seccond
var energy_drain_rate: float = energy_start / hungry_time
var age: float = 600.0 #second

var child_scene = preload("res://scenes/agents/worker/worker.tscn")
var child: Node2D

var mood: String
var inside_house: bool = false
var is_able_to_have_child: bool = true

var money: int = 0
var debt: int = 0
var debt_calculate_cycle_start: float = Data.DebtCalculateCycleStart
var interest_rates: float = Data.InterestratesStart / 100
var debt_calculate_cycle: float

var data_calculate_cycle_start: float = 30.0
var data_calculate_cycle: float
var income: int
var all_income: float
var income_statement: Array = [0,0,0,0,0]
var expenditure_statement: Array = [0,0,0,0,0]
var average_income : float
var expense: int

var food_limit: int = 50 #pieces
var food: int = 100 #pieces
var food_reserve_need: int
var food_need: int
var food_price: int
var retire: bool = false
var buy_food_status: bool = true

var data_scope: float = 6.0
var status: String
var all_work_target: Array
var all_buy_target: Array
var buy_target: Node2D
var work_target: Node2D
var current_target: Node2D
var time_value: float

var house: Node2D
var work_state: String
var buy_food_state: String


func aging(delta,current_age):
	current_age -= delta
	return current_age
	
func food_reserve_need_calculating():
	if house:
		food_reserve_need = house.food_reserve_limit - house.food_reserve
		
func food_need_calculating():
	food_need = food_limit - food
	
func energy_drain(delta,current_energy):
	current_energy -= delta * energy_drain_rate * energy_drain_index
	return current_energy

func _financial():
	income_statement.push_front(income)
	expenditure_statement.push_front(expense)
	income_statement.resize(int(data_scope))
	
	for incomes in income_statement:
		all_income += incomes
	average_income = all_income / float(data_calculate_cycle_start * data_scope)
	
	if false and name == "worker":
		print(name)
		print(income_statement)
		print(average_income)
	all_income = 0
	income = 0
	expense = 0
	
func _ready():
	time_value = 1.0
	energy = energy_start
	debt_calculate_cycle = debt_calculate_cycle_start
	data_calculate_cycle = data_calculate_cycle_start


func _process(delta: float):
	energy = energy_drain(delta,energy)
	age = aging(delta,age)
	food_need_calculating()
	food_reserve_need_calculating()
	
	if house != null and inside_house: #Having a children
		if house.food_reserve >= 150 and  is_able_to_have_child and age <= 540.0:
			is_able_to_have_child = false
			child = child_scene.instantiate()
			house.food_reserve -= 150
			get_tree().get_first_node_in_group("WorkerNode").add_child(child)
			child.global_position = self.global_position
			
	
	all_work_target = get_tree().get_nodes_in_group("WorkBuilding")
	all_buy_target = get_tree().get_nodes_in_group("FoodMarket")
	buy_target = Function.find_best_target_buy(house,all_buy_target,speed_pixel_per_second,time_value)
	work_target = Function.find_best_target_work(house,all_work_target,speed_pixel_per_second,time_value)
		
	if buy_target != null:
		food_price = buy_target.price
	debt_calculate_cycle -= delta
	
	#Retire condition
	if money - debt >= int(age * float(food_price) * 1.2) or house.food_reserve >= age:
		retire = true
	else:
		retire = false
		
	if debt > 0 and interest_rates > 0 and debt_calculate_cycle <= 0:
		debt = Function.debt_compounding(debt,interest_rates)
		debt_calculate_cycle = debt_calculate_cycle_start
		
	data_calculate_cycle -= delta
	if data_calculate_cycle <= 0:
		_financial()
		data_calculate_cycle = data_calculate_cycle_start
		
		
	time_value = average_income * 1.1

func _physics_process(_delta):
	move_and_slide()
	
	if energy <= 0 or age <= 0:
		house.house_owner = null
		
		
		if child == Node2D and debt < money:
			child.money += money
			child.debt += debt
			money = 0
		queue_free()
