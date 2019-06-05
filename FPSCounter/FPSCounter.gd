extends Node2D

onready var label = get_node("Label")
onready var count_label = get_node("CountLabel")

const WHITE = Color(255,255,255)
const RED = Color(255,0,0)
const GREEN = Color(0,255,0)
const SWITCH_DELAY_MAX = 0.5

#var visible = true
var switch_delay = 0

func _ready():
	set_color(WHITE)
	set_process(true)
	set_process_input(true)
	toggle_visible()

func _process(delta):
	if(switch_delay > 0):
		switch_delay -= delta
	count_label.set_text(str(Engine.get_frames_per_second()))
	if(Engine.get_frames_per_second() > 200):
		set_color(GREEN)
	elif(Engine.get_frames_per_second() < 60):
		set_color(RED)
	else:
		set_color(WHITE)

func set_color(color):
	label.set("custom_colors/font_color",color)
	count_label.set("custom_colors/font_color",color)

func toggle_visible():
	if(switch_delay > 0):
		return
	switch_delay = SWITCH_DELAY_MAX
	if(visible):
#		set_opacity(0
		set_modulate(Color(get_modulate().r, get_modulate().g, get_modulate().b, 0))
		visible = false
	else:
#		set_opacity(1)
		set_modulate(Color(get_modulate().r, get_modulate().g, get_modulate().b, 1))
		visible = true

func _input(event):
	if event is InputEventKey:
		if(event.scancode == KEY_F):
			toggle_visible()