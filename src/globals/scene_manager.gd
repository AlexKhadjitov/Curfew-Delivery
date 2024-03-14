extends Node

var player: Player 



func change_scene(from: Node, to: PackedScene, player_to_saved_spawnpoint: bool = false):
	player = get_tree().get_nodes_in_group("Player")[0]

	var to_inst = to.instantiate()
	get_tree().get_root().add_child(to_inst)

	player.get_parent().remove_child(player)
	to_inst.add_child(player)

	get_tree().get_root().remove_child(from)

	player_to_spawnpoint(player_to_saved_spawnpoint)

func player_to_spawnpoint(player_to_saved_spawnpoint: bool):
	player = get_tree().get_nodes_in_group("Player")[0]

	var spawnpoints = get_tree().get_nodes_in_group("Spawnpoints")
	var spawnpoint: Node
	if player_to_saved_spawnpoint:
		for s in spawnpoints:
			if s.name == SaveDataManager.current_save_data.spawn_point_name:
				spawnpoint = s
				break
	if spawnpoint == null:
		spawnpoint = spawnpoints[0]
	player.global_transform = spawnpoint.global_transform
	player.rotation.x = 0
	player.rotation.z = 0
