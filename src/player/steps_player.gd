extends RayCast3D

@onready var player: Player = $"../"
@onready var steps_player: AudioStreamPlayer3D = $"../StepsPlayer"

var walk_period: float = 0.5
var crouch_period: float = 1
var run_period: float = 0.25

var time_since_step: float = 0

func _ready():
	steps_player.stream = SurfaceSounds.get_step_sound("")

var time_since_check = 0
func _physics_process(delta):
	time_since_check += delta
	if time_since_check < 0.5:
		return
	time_since_check = 0
	
	var object = get_collider()

	steps_player.stream = SurfaceSounds.get_step_sound("")
	

func _process(delta):
	time_since_step += delta
	if Input.get_vector("left", "right", "forward", "backward") == Vector2.ZERO or not player.is_on_floor():
		return

	if player.state == Player.State.Walking:
		steps_player.volume_db = 0
	elif player.state == Player.State.Crouching:
		steps_player.volume_db = -5
	elif player.state == Player.State.Running:
		steps_player.volume_db = 5

	if player.state == Player.State.Walking and time_since_step >= walk_period:
		print(steps_player.stream)
		steps_player.play()
		time_since_step = 0
	elif player.state == Player.State.Crouching and time_since_step >= crouch_period:
		steps_player.play()
		time_since_step = 0
	elif player.state == Player.State.Running and time_since_step >= run_period:
		steps_player.play()
		time_since_step = 0
	
