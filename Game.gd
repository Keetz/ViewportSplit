extends Node2D

onready var minimum_size = Vector2(1920, 2160)

onready var top_screen = get_node("TopScreen")
onready var bottom_screen = get_node("BottomScreen")

onready var mouse_particles = get_node("CPUParticles2D")

func _ready():
	get_tree().get_root().connect("size_changed", self, "window_resize")
	
	yield(get_tree(), "idle_frame")
	window_resize()

func window_resize():
	## For this to work with the optimization the project window size
	### needs to be the same as the actual window size and the Viewport
	### size needs to be half the window size
	## e.g. Window (3840, 1080) and each Viewport (1920, 1080)
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

var pressed = false

func _input(event):
#	if get_tree().get_root().has_node("Node"):
#		if event is InputEventMouseMotion or event is InputEventMouseButton:
#			var viewport_actual_size = get_tree().get_root().get_size_override() / 4
#
#			var input_offset
#
#			# Bottom Screen
#			if event.position.x <= get_viewport().size.x:
#				var fraction_x = event.position.x / get_viewport().size.x
#				var viewport_difference = viewport_actual_size.x - get_viewport().size.x
#
#				var offset_x = -event.position.x + fraction_x * (get_tree().get_root().size.x + viewport_difference * 2) * 2
#				var offset_y = event.position.y * (viewport_actual_size.y / get_tree().get_root().size.y - 1) + viewport_actual_size.y * 2
#
#				input_offset = Transform2D(0, Vector2(offset_x, offset_y))
#
#			# Top Screen
#			else:
#				var fraction_x = event.position.x / get_viewport().size.x
#				var viewport_difference = viewport_actual_size.x - get_viewport().size.x
#
#				var offset_x = -event.position.x + fraction_x * (get_tree().get_root().size.x + viewport_difference * 2) * 2 - get_tree().get_root().get_size_override().x
#				var offset_y = event.position.y * (viewport_actual_size.y / get_tree().get_root().size.y - 1)
#
#				input_offset = Transform2D(0, Vector2(offset_x, offset_y))
#
#			event = event.xformed_by(input_offset)
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		pressed = event.pressed
		
		if event.pressed:
			mouse_particles.set_position(Vector2(event.position.x, event.position.y))
			mouse_particles.set_emitting(true)
		
		else:
			mouse_particles.set_emitting(false)
	
	if event is InputEventMouseMotion:
		if pressed:
			mouse_particles.set_position(Vector2(event.position.x, event.position.y))
