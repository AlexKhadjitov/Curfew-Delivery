extends Node

var player: Player 

func _ready():
    player = get_tree().get_nodes_in_group("Player")[0]

func change_scene(from: Node, to: PackedScene, player_to_saved_spawnpoint: bool = false):
    var to_inst = to.instantiate()
    get_tree().get_root().add_child(to_inst)

    player.get_parent().remove_child(player)
    to_inst.add_child(player)

    get_tree().get_root().remove_child(from)

    player_to_spawnpoint(player_to_saved_spawnpoint)

func player_to_spawnpoint(player_to_saved_spawnpoint: bool):
    var spawnpoints = get_tree().get_nodes_in_group("Spawnpoints")
    var spawnpoint: Node
    if player_to_saved_spawnpoint:
        spawnpoint = spawnpoints[SaveDataManager.current_save_data.spawn_point]
    else:
        spawnpoint = spawnpoints[0]
    player.global_transform = spawnpoint.global_transform