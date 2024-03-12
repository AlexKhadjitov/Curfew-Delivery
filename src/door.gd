extends StaticBody3D
class_name Door
 

@export var scene_from: Node
@export var scene_to: String
@export var packed_scene_to: PackedScene
@export var save_spawnpoint: bool = false
@export var save_spawnpoint_name: String = ""
@onready var spawnpoint_node
@export var to_saved_spawnpoint: bool = false

@onready var sound_player: AudioStreamPlayer3D = $"AudioStreamPlayer3D"
@export var open_sound: AudioStream = preload("res://audio/doors/normal_door_open.wav")
@export var open_locked_sound: AudioStream = preload("res://audio/doors/normal_door_open_locked.wav")
@export var unlock_sound: AudioStream = preload("res://audio/doors/normal_door_unlock.wav")

@export var locked = false

func _ready():
	if save_spawnpoint and has_node("Spawnpoint"):
		var spwn = get_node("Spawnpoint")
		spwn.name = save_spawnpoint_name
		spwn.add_to_group("Spawnpoints")

func interact():
	if locked:
		sound_player.stream = open_locked_sound
		sound_player.play()
		return
	
	sound_player.stream = open_sound
	sound_player.play()

	if save_spawnpoint:
		SaveDataManager.current_save_data.spawn_point_name = save_spawnpoint_name
	
	if packed_scene_to == null:
		SceneManager.change_scene(scene_from, load(scene_to), true)
	else:
		SceneManager.change_scene(scene_from, packed_scene_to, true)

func unlock():
	sound_player.stream = unlock_sound
	sound_player.play()
	locked = false
