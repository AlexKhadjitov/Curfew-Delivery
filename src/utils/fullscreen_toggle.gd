extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		var window = get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
			return
		if window.mode == Window.MODE_WINDOWED or window.mode == Window.MODE_MAXIMIZED:
			window.mode = Window.MODE_FULLSCREEN
			return

	if Input.is_action_just_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)