extends Control

var pause = false

signal paused
signal resumed
signal quit

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	GlobalSignals.add_emitter('paused', self)
	GlobalSignals.add_emitter('resumed', self)
	GlobalSignals.add_emitter('quit', self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	pause = false
	resumed.emit()
	self.hide()


func _on_quit_pressed():
	quit.emit()



func _input(event):
	if event.is_action_pressed("pause"):
		if pause == false:
			pause = true
			paused.emit()
			self.show()
		else:
			pause = false
			resumed.emit()
			self.hide()