extends Sprite2D
class_name Market

var money: int = 1000000000
var debt: int = 0
var paid: int

var profit: float
var profit_statement: Array
var sales: int
var sales_statement: Array
var income: int
var income_statement: Array = [0,0]
var income_growth_statement: Array
var expense: int
var expenditure_statement: Array = [0,0]
var expenditure_growth_statement: Array
var productivity: int
var productivity_statement: Array = [0,0,0,0,0,0,0,0,0,0,0]

var data_calculate_cycle_start: float = 30.0
var data_calculate_cycle: float
var interest_rates = Data.InterestratesStart / 100
var debt_calculate_cycle_start: float = Data.DebtCalculateCycleStart
var debt_calculate_cycle: float

var price: int = 5775
var food_stock: int = 1000
var food_stock_limit: int = 100000
var price_offer: int = 5250
var pieces: int
var sell_status: bool = true
var buy_status: bool = true
var price_plan: int = -1
var price_change: float = 0
var margin: float = 0.05
var price_change_rates: float = 1.1


func _adjust_price(plan):
	price_change = ((float(price) * (price_change_rates - 1.0)) / float(price) * plan) * 100.0
	price = roundi(float(price) * float(price_change_rates ** plan))
	price_plan = plan


func _financial():
	profit = Function.profit_calculation(income,expense)
	income_statement.push_front(income)
	#expenditure_statement.push_front(expense)
	#sales_statement.push_front(sales)
	productivity_statement.push_front(productivity)
	profit_statement.push_front(profit)
	income_growth_statement.push_front(Function.data_growth_calculation(income_statement))
	#expenditure_growth_statement.push_front(Function.data_growth_calculation(expenditure_statement))
	
	
	income_statement.resize(5)
	#expenditure_statement.resize(5)
	#sales_statement.resize(5)
	profit_statement.resize(5)
	income_growth_statement.resize(5)
	#expenditure_growth_statement.resize(5)
	productivity_statement.resize(11)

	if true:
		print("**",name)
		print(income_statement)
		print(income_growth_statement)
		print(productivity_statement,Function._find_median(productivity_statement))
	income = 0
	expense = 0
	sales = 0
	productivity = 0
	
func _ready():
	data_calculate_cycle = data_calculate_cycle_start
	
	$Area2D.body_entered.connect(func buy_food(body: Node2D):
		pieces = body.food_need
		if body and body.status == "BuyFood" and body.current_target == self and sell_status == true:
			body.visible = false
			body.buy_food_state = "buying"
			body.food += pieces
			body.money -= price * pieces
			food_stock -= pieces
			money += price * pieces
			income += price * pieces
			sales += pieces
			body.buy_food_state = "success"
			await get_tree().create_timer(1.0).timeout
			
		elif body.status == "BuyFood" and body.current_target == self and sell_status == false:
			body.buy_food_state = "fail"
			)
	$Area2D.body_exited.connect(func exit(body: Node2D):
		body.visible = true
		)
	

func _process(delta: float):
	if debt > 0 and interest_rates > 0 and debt_calculate_cycle <= 0:
		debt = Function.debt_compounding(debt,interest_rates)
		debt_calculate_cycle = debt_calculate_cycle_start
	
	data_calculate_cycle -= delta
	
	if data_calculate_cycle <= 0:
		_financial()
		if  income_growth_statement.size() >= 2:
			if income_growth_statement[0] <= price_change:
				
				if price_plan == 1:
					_adjust_price(-1)
				elif price_plan == -1:
					_adjust_price(1)
					
			elif income_growth_statement[0] > price_change:
				
				if price_plan == -1:
					_adjust_price(-1)
				elif price_plan == 1:
					_adjust_price(1)
					
			else: _adjust_price(1)
					
		margin = float(roundf(food_stock / 1428.0) + 10.0) / 100.0
		price_offer = int(float(price) * (1.0 - margin))
		print("margin: ", margin * 100 , "%")
		data_calculate_cycle = data_calculate_cycle_start
		
		
	if food_stock <  food_stock_limit * 0.003:
		sell_status = false
	elif food_stock >= food_stock_limit * 0.003:
		sell_status = true
		
	if food_stock >= food_stock_limit:
		buy_status = false
	elif food_stock < roundi(float(food_stock_limit) * 0.6):
		buy_status = true
		
