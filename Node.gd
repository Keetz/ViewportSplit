extends Node

# I have written this to work with the 3840x1080 physical device you have described

#  *--------------*
#  |              |       *--------------*--------------*
#  |        t     |       |              |              |
#  *--------------*   ->  |         b    |        t     |
#  |              |       *--------------*--------------*
#  |        b     |
#  *--------------*

func _ready():
	# Tell root Viewport not to render
	get_viewport().set_attach_to_screen_rect(Rect2())

	# Share world ("Game") between the two viewports
	$Top.world_2d = $Bottom.world_2d

	get_viewport().connect("size_changed", self, "handle_size_changed")
	handle_size_changed()
#
func handle_size_changed():
	# Tell root Viewport not to render
	get_viewport().set_attach_to_screen_rect(Rect2())
	
	# Modify size becuase of the layout of the physical device
	# current_size is the size of each viewport in window coordinates
	var current_size = OS.get_window_size()
	
	# Viewport size is ignored when using the optimization, but we set the size of each viewport
	# to the size that ("Game") is being rendered to so we don't have to modify code in ("Game")
	$Top.size = Vector2(0.5, 2.0) * current_size
	$Bottom.size = Vector2(0.5, 2.0) * current_size

	current_size.x /= 2

	var minimum_size = Vector2(1920, 1080)

	# This calculation stays the same
	var scale_factor = minimum_size.y / current_size.y
	var new_size = Vector2(current_size.x * scale_factor, minimum_size.y)

	# I used current_size to calculate the scaling here as we require the scale
	# between the current_size and new_size in order to zoom the cameras correctly
	if new_size.x < minimum_size.x:
		scale_factor = minimum_size.x / current_size.x
		new_size = Vector2(minimum_size.x, current_size.y * scale_factor)

	# The big difference now is that you need to move the cameras to capture
	# the Part of the game you want, and you have to set the position of the
	# Viewports manually rather than letting the TextureRect handle the scaling
	# for you
	$Bottom/Camera2D.zoom = Vector2(scale_factor, scale_factor)
	$Top/Camera2D.zoom = Vector2(scale_factor, scale_factor)
	$Bottom/Camera2D.position = Vector2(0, new_size.y)
	$Top/Camera2D.position = Vector2(0, 0)

	# Bottom is drawn on the left half of the screen, while Top is drawn
	# on the Right. These sizes need to be in relation to the actual window size
	$Bottom.set_attach_to_screen_rect(Rect2(0, 0, current_size.x, current_size.y))
	$Top.set_attach_to_screen_rect(Rect2(current_size.x, 0, current_size.x, current_size.y))