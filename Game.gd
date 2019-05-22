extends Node2D

onready var minimum_size = Vector2(1920, 2160)

onready var top_screen = get_node("TopScreen")
onready var bottom_screen = get_node("BottomScreen")

func _ready():
	get_tree().get_root().connect("size_changed", self, "window_resize")
	
	yield(get_tree(), "idle_frame")
	window_resize()

func window_resize():
	var current_size = get_viewport().size
	
	var scale_factor = minimum_size.y / current_size.y
	var new_size = Vector2(current_size.x * scale_factor, minimum_size.y)
	
	if new_size.x < minimum_size.x:
		scale_factor = minimum_size.x / new_size.x
		new_size = Vector2(minimum_size.x, new_size.y * scale_factor)
	
	get_tree().get_root().set_size_override(true, new_size)
	
	# Positioning
	var top_pos = Vector2(new_size.x / 2, new_size.y / 4)
	var bot_pos = Vector2(new_size.x / 2, new_size.y - new_size.y / 4)
	
	top_screen.position = top_pos
	bottom_screen.position = bot_pos