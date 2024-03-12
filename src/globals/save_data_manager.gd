extends Node

var current_save_data: SaveData

func _ready():
    if not DirAccess.dir_exists_absolute("user://Saves"):
        DirAccess.make_dir_absolute("user://Saves")

    if load("user://current_save.tres") == null:
        current_save_data = SaveData.new()
        ResourceSaver.save(current_save_data, "user://current_save.tres")
    current_save_data = load("user://current_save.tres")