extends Sprite2D
class_name WoodMarket

var money: int = 100000000
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

var data_calculate_cycle_start: float = 5.0
var data_calculate_cycle: float
var interest_rates = Data.InterestratesStart / 100
var debt_calculate_cycle_start: float = Data.DebtCalculateCycleStart
var debt_calculate_cycle: float

var price: int = 1170
var goods_stock: int = 500
var goods_stock_limit: int = 100000
var price_offer: int = 1060
var pieces: int
var sell_status: bool = true
var buy_status: bool = true
var price_plan: int = -1
var price_change: float = 0
var margin: float = 0.1
var price_change_rates: float = 1.1


func _adjust_price(plan):
	price_change = ((float(price) * (price_change_rates - 1.0)) / float(price)) * 100.0
	price = roundi(float(price) * float(price_change_rates ** plan))
	price_plan = plan


func _ready():
	data_calculate_cycle = data_calculate_cycle_start
	
	$Area2D.body_entered.connect(func buy_food(body: Node2D):
		pieces = body.wood_need
		if body and body.status == "BuyFood" and body.current_target == self and sell_status == true:
			body.visible = false
			body.buy_food_state = "buying"
			body.food += pieces
			body.money -= price * pieces
			goods_stock -= pieces
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
		Function._financial(self,1,1,1,1,0)
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
					
		margin = float(roundf((goods_stock / 20.0) ** (0.5)) + 5.0) / 100.0
		price_offer = int(float(price) * (1.0 - margin))
		print("margin: ", margin * 100 , "%")
		print("income:",income_statement)
		print("income_growth:",income_growth_statement)
		data_calculate_cycle = data_calculate_cycle_start
		
	if goods_stock <  goods_stock_limit * 0.005:
		sell_status = false
	elif goods_stock >= goods_stock_limit * 0.005:
		sell_status = true
		
	if goods_stock >= goods_stock_limit:
		buy_status = false
	elif goods_stock < roundi(float(goods_stock_limit) * 0.6):
		buy_status = true
		
