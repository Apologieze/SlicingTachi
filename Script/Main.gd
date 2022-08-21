extends Node2D

const RATIO = 9.0/16.0

func _ready():
	OS.window_size = Vector2(1280,720)
	get_tree().get_root().connect("size_changed", self, "resized")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("screen_key"):
		OS.window_fullscreen = not OS.window_fullscreen
	if event.is_action_pressed("ui_accept"):
		print(OS.window_size)
		


func resized():
	OS.window_size.y = OS.window_size.x*RATIO
	
