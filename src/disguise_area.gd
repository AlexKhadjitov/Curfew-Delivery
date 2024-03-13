extends Area3D

var player_inside: bool = false

func _ready():
	body_entered.connect(player_entered)
	body_exited.connect(player_exited)


func _process(_delta):
	if player_inside and has_overlapping_bodies():
		var player: Player = get_overlapping_bodies()[0]
		player.disguised = true


func player_entered(player):
	player_inside = true
	player.disguised = true


func player_exited(player):
	player_inside = false
	player.disguised = false