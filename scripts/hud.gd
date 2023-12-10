extends CanvasLayer

@onready var player_controller = %PlayerController
@onready var crosshair = get_node("Crosshair")

var test = false
func _ready():

	pass

func _physics_process(_delta):
	pass
	# if (!test):
	# 	crosshair.close = true
	# 	test = true

	# if player_controller.aiming:
	# 	#crosshair.show()
	# 	crosshair.close = true
	# else:
	# 	crosshair.open = true
	# 	#crosshair.hide()
