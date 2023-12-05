extends Node

@onready var pause_menu = %PauseMenu
@onready var game = %Game

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalSignals.add_listener("paused", self, "_on_paused_game")
	GlobalSignals.add_listener("resumed", self, "_on_resumed_game")
	GlobalSignals.add_listener("quit", self, "_on_quit_game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	pass

func _on_paused_game():
	# print('game paused')
	game.process_mode = Node.PROCESS_MODE_DISABLED
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#call some other functions to notify player2 in multiplayer that player1 paused the game

func _on_resumed_game():
	# print('game unpaused')
	game.process_mode = Node.PROCESS_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_game():
	get_tree().quit()

