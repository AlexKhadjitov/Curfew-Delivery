extends StaticBody3D

@export var scene_from: Node
@export var scene_to: PackedScene
@export var to_saved_spawnpoint: bool = false

@onready var sound_player: AudioStreamPlayer3D = $"AudioStreamPlayer3D"
@export var open_sound: AudioStream = preload("res://audio/doors/normal_door_open.wav")
@export var open_locked_sound: AudioStream = preload("res://audio/doors/normal_door_open_locked.wav")
@export var unlock_sound: AudioStream = preload("res://audio/doors/normal_door_unlock.wav")

@export var locked = false


func interact():
	if locked:
		sound_player.stream = open_locked_sound
		sound_player.play()
		return
	
	sound_player.stream = open_sound
	sound_player.play()

	SceneManager.change_scene(scene_from, scene_to, true)

func unlock():
	sound_player.stream = unlock_sound
	sound_player.play()
