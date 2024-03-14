extends Node3D

@export var packed_scene: PackedScene
@export var main_door: Door
@export var door: Door
@onready var food: Node3D = $"Food"
@export var no_food_dialouge: Array[String]
@export var food_dialouge: Array[String]
@onready var voice_player: AudioStreamPlayer3D = $"AudioStreamPlayer3D"

func _ready():
	door.on_interact.connect(door_interact)


func door_interact():
	if not SaveDataManager.current_save_data.first_quest_got_order:
		DialougeManager.start_dialouge(no_food_dialouge, "no_food_dialouge", play_voice, 0.05)
		DialougeManager.play_dialouge("no_food_dialouge")
		return

	DialougeManager.start_dialouge(food_dialouge, "food_dialouge", play_voice, 0.05)
	DialougeManager.play_dialouge("food_dialouge")

	if not DialougeManager.get_dialouge("food_dialouge").on_end.is_connected(food_dialouge_ended):
		DialougeManager.get_dialouge("food_dialouge").on_end.connect(food_dialouge_ended)
	return

func play_voice():
	voice_player.pitch_scale = 1 - (randf()-0.5)/5
	voice_player.play()

func food_dialouge_ended():
	SaveDataManager.current_save_data.first_quest_completed = true
	food.visible = true
	main_door.to_saved_spawnpoint = false
	main_door.packed_scene_to = packed_scene