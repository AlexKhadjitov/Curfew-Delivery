extends Sprite3D

@export var speaking_area: Area3D
var player_in_area: bool = false

func _ready():
	speaking_area.body_entered.connect(player_entered)
	speaking_area.body_exited.connect(player_exited)

	modulate.a = 0
	position.z = -0.5

var t: float = 0
func _process(delta):
	t += delta * 2

	if player_in_area:
		modulate.a = move_toward(modulate.a, 1, delta)
		position.z = move_toward(position.z, 0.5, delta)
	else:
		modulate.a = move_toward(modulate.a, 0, delta)
		position.z = move_toward(position.z, -0.5, delta)

	if floori(t) % 10 == 9:
		scale.y = abs(cos((t-3)*PI))

func player_entered(body):
	player_in_area = true

func player_exited(body):
	player_in_area = false
