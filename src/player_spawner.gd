extends Node3D

@onready var player_scene: PackedScene = preload("res://player.tscn")

func _ready():
    if get_tree().get_nodes_in_group("Player") == []:
        var player = player_scene.instantiate()
        player.global_transform = global_transform
        get_parent().add_child.call_deferred(player)