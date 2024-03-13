extends Control

@onready var player: Player = $"../../"

func _ready():
    modulate.a = 0

func _process(delta):
    if player.disguised:
        modulate.a = move_toward(modulate.a, 1, delta*3)
    else:
        modulate.a = move_toward(modulate.a, 0, delta*3)