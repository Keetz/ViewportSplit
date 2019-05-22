extends Node

onready var root_viewport = get_tree().get_root()
onready var viewport = get_node("Viewport")

onready var texture_top = get_node("TextureRectTop")

func _ready():
	root_viewport.connect("size_changed", self, "handle_size_changed")
	handle_size_changed()

func handle_size_changed():
	var current_size = OS.get_window_size()
	current_size.x /= 2
	current_size.y *= 2
	
	var minimum_size = Vector2(1920, 2160)
	
	var scale_factor = minimum_size.y / current_size.y
	var new_size = Vector2(current_size.x * scale_factor, minimum_size.y)
	
	if new_size.x < minimum_size.x:
		scale_factor = minimum_size.x / new_size.x
		new_size = Vector2(minimum_size.x, new_size.y * scale_factor)
	
	viewport.size = new_size
	
	texture_top.rect_position.x = new_size.x / 2
