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

func _input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		var input_offset = Transform2D(0, Vector2(-event.position.x, -event.position.y)) # Always (0, 0)
		
		# Top Screen
		if event.position.x >= viewport.size.x / 2 and event.position.y < viewport.size.y:
			var offset_x = event.position.x - viewport.size.x
			var offset_y = -event.position.y / 2
			
			input_offset = Transform2D(0, Vector2(offset_x, offset_y))
		
		# Bottom Screen
		elif event.position.x < viewport.size.x / 2 and event.position.y < viewport.size.y:
			var offset_x = event.position.x
			var offset_y = viewport.size.y / 2 * (1 - event.position.y / viewport.size.y)
			
			input_offset = Transform2D(0, Vector2(offset_x, offset_y))
		
		viewport.input(event.xformed_by(input_offset))
	
	else:
		viewport.input(event)

func _unhandled_input(event):
	viewport.unhandled_input(event)