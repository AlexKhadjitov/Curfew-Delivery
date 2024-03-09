extends Camera3D

@export_range(1, 10) var sensivity: float

@onready var player: Player = $".."

var look_rot = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_input(true)

func _process(delta):
	look_rot.x = clampf(look_rot.x, -90, 90)
	rotation_degrees.x = look_rot.x
	player.rotation_degrees.y = look_rot.y

	#if Input.is_action_just_pressed("escape"):
	#	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#	else:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensivity/20)
		look_rot.x -= (event.relative.y * sensivity/20)
