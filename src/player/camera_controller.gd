extends Camera3D

@export_range(1, 10) var sensivity: float
@export var def_fov: float

@onready var player: Player = $".."

var look_rot = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_input(true)

	fov = def_fov

func _process(delta):
	look_rot.x = clampf(look_rot.x, -90, 90)
	rotation_degrees.x = look_rot.x
	player.rotation_degrees.y = look_rot.y

	if player.state == Player.State.Running:
		fov = move_toward(fov, def_fov+10, delta*20)
	else:
		fov = move_toward(fov, def_fov, delta*20)

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensivity/20)
		look_rot.x -= (event.relative.y * sensivity/20)
