class_name LumberMill
extends Sprite2D
var money: int = 10000000
var debt: int
var paid: int
var interest_rates = Data.InterestratesStart / 100 + 1
var debt_calculate_cycle_start: float = Data.DebtCalculateCycleStart
var debt_calculate_cycle: float
var pieces: int
var goods_stock: int = 0
var goods_stock_limit:int = 10000
var wage_offer: int = 1000
var player: Node2D
var time: float
var all_sell_target: Array
var sell_target: Node2D
var employee_name_list: Array
var employee_wage_list: Array

var production_growth_statement: Array = [0,0]
var profit: float
var profit_statement: Array
var sales_statement: Array
var sales: int
var income: int
var income_statement: Array = [0,0]
var income_growth_statement: Array = [0,0]
var expense: int
var expenditure_statement: Array = [0,0]
var expenditure_growth_statement: Array = [0,0]
var production: int
var production_statement: Array = [0,0]
var profitable: bool

var data_calculate_cycle_start: float = randf_range(4,6)
var data_calculate_cycle: float

var goods_produce_amount: int = 20
var goods_produce_multiplier: int = 3
var hire_status: bool = true
var sell_status: bool = true

var invest_plan: int
var price_plan: int
var price_change: float = 0
var wage_plan: int = 1
var wage_change: float = 0
var margin: float = 1.1
func _get_class_name():
	return 'LumberMill'
func _adjust_wage(plan):
	wage_change = ((float(wage_offer) * (margin - 1)) / float(wage_offer)) * 100.0
	wage_offer = roundi(float(wage_offer * float(margin ** plan) ))
	wage_plan = plan
	
func _ready():
	data_calculate_cycle = data_calculate_cycle_start
	income_statement.resize(5)
	expenditure_statement.resize(5)
	profit_statement.resize(5)
	sales_statement.resize(5)
	production_statement.resize(5)
	income_growth_statement.resize(5)
	expenditure_growth_statement.resize(5)
	production_growth_statement.resize(5)
	$Area2D.body_entered.connect(func producing_food(body: Node2D):
		if body and body.status == "Work" and body.energy >= goods_produce_amount and body.current_target == self and hire_status:
			body.visible = false
			body.work_state = "doing"
			
			Function.produce_goods(self,body,wage_offer,goods_produce_amount,body.goods_produce_multiplier['wood'])
			expense += goods_produce_amount * wage_offer
			production += goods_produce_amount
			body.income += goods_produce_amount * wage_offer
			body.work_state = "success"
			body.mood = "tired"
			await get_tree().create_timer(1.5).timeout
		elif body.status == "Work" and body.energy >= 50 and body.current_target == self and !hire_status:
			body.work_state = "fail"
			)
		
	$Area2D.body_exited.connect(func exit(body: Node2D):
		body.visible = true
		)
		
	debt_calculate_cycle = debt_calculate_cycle_start

func _process(delta: float):
	all_sell_target = get_tree().get_nodes_in_group("WoodMarket")
	sell_target = Function.find_best_target_sell(self,all_sell_target,1,1)
	profitable = round(sell_target.price_offer) >= round(wage_offer * 1.05)
	if sell_target:
		if goods_stock > 0 and sell_target.buy_status and profitable:
			money += goods_stock * sell_target.price_offer
			sell_target.money -= goods_stock * sell_target.price_offer
			sell_target.goods_stock += goods_stock
			sell_target.expense += goods_stock * sell_target.price_offer
			sell_target.productivity += goods_stock
			goods_stock = 0
		else:
			hire_status = false
	else:
		hire_status = false
		
		
	data_calculate_cycle -= delta
	
	if data_calculate_cycle <= 0:
		Function._financial(self,1,1,1,1,1)
		
		if  production_growth_statement.size() >= 2:
			if production_statement[0] == 0 and profitable:
				_adjust_wage(1)
				
			elif production_growth_statement[0] <= wage_change:
				if wage_plan == 1 or !profitable: 
					_adjust_wage(-1)
				elif wage_plan == -1 and profitable:
					_adjust_wage(1)
					
			elif production_growth_statement[0] > wage_change:
				if wage_plan == -1 or !profitable:
					_adjust_wage(-1)
				elif wage_plan == 1 and profitable:
					_adjust_wage(1)
					
			
		data_calculate_cycle = data_calculate_cycle_start
		
	debt_calculate_cycle -= delta
	if debt > 0 and interest_rates > 0 and debt_calculate_cycle <= 0:
		debt_calculate_cycle += debt_calculate_cycle_start
		debt = Function.debt_compounding(debt,interest_rates)
		
	if money < sell_target.price_offer * 500 or goods_stock >= goods_stock_limit:
		hire_status = false
	elif money >= sell_target.price_offer * 500 and goods_stock < goods_stock_limit:
		hire_status = true
		
func _physics_process(_delta):
	pass
	
