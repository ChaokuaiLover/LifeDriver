extends State
class_name WorkerPayLoan
@export var worker: Node2D
var all_target: Array
var direction: Vector2

func Enter():
	worker.velocity = Vector2(0,0) * 0
	worker.money -= worker.debt
	worker.debt = 0

func Update(_delta: float):
	Transitioned.emit(self, "StoreFood")
