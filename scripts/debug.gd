extends CanvasLayer

@onready var player = %PlayerController
@onready var container = get_node("VBoxContainer")
# Called when the node enters the scene tree for the first time.
var data_dict = {}
func _ready():

	add_data("pos", player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_data("pos", player.get_player_pos())

func add_data(data_name, data):
	if data_name in data_dict:
		if data_dict[data_name].text != str(data_name) + ": " + str(data):
			data_dict[data_name].text = str(data_name) + ": " + str(data)
			return
	else:
		var data_node = Label.new()
		var label_settings = LabelSettings.new()
		label_settings.font_color = Color(1, 0, 0, 1)
		data_node.label_settings = label_settings
		data_node.text = str(data_name) + ": " + str(data)
		container.add_child(data_node)

		data_dict[data_name] = data_node
