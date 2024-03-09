extends ProgressBar


@onready var player: Player = $"../../"
@onready var low_bound_indicator: ColorRect = $"LowBoundIndicator"

var last_ran: float = 0 #time since player ran

func _ready():
	max_value = player.max_stamina
	modulate.a = 0
	low_bound_indicator.anchor_right = player.stamina_low_bound/player.max_stamina
	low_bound_indicator.anchor_left = low_bound_indicator.anchor_right
	print(player.stamina_low_bound/player.max_stamina)


func _physics_process(delta):
	value = player.stamina

	if player.state == Player.State.Running:
		last_ran = 0
		modulate.a = move_toward(modulate.a, 1, delta)
	else:
		last_ran += delta
	
	if last_ran > player.stamina_low_bound/player.stamina_low_increase + 1:
		modulate.a = move_toward(modulate.a, 0, delta/2)

	#if player.stamina < player.stamina_low_bound:
	#	var fill_stylebox: StyleBoxFlat = get_theme_stylebox("fill")
	#	print(fill_stylebox.bg_color)
