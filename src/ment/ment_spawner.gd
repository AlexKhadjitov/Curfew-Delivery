extends Node
class_name MentSpawner

## How much of spawners to fill with police
@export var fill_count: int
var _fill_count

@onready var ment_scene: PackedScene = preload("res://ment.tscn")

func _ready():
    _fill_count = fill_count
    var children_array: Array[Node] = get_children()
    children_array.shuffle()

    for child: Node in children_array:
        if _fill_count > 0:
            spawn_ment(child)
            _fill_count -= 1

func spawn_ment(spawn: Node3D):
    var ment_instance = ment_scene.instantiate()

    spawn.add_child(ment_instance)