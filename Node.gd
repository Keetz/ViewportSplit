extends Node

func _ready():
	#Do not render the main viewport
	#	Without this the empty main viewport will draw over the others
	#	becuase it is drawn last
	get_viewport().set_attach_to_screen_rect(Rect2())
	
	#Share world ("Game") between the two viewports
	$Viewport2.world_2d = $Viewport.world_2d
	
	#First viewport will take up the top half of the screen
	$Viewport.set_attach_to_screen_rect(Rect2(0, 0, 960, 540))
	#Second viewport takes up the bottom half of the screen
	$Viewport2.set_attach_to_screen_rect(Rect2(0, 540, 960, 540))
