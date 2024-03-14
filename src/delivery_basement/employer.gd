extends Node
class_name Employer


@export_multiline var intro_dialouge: Array[String]

@export_multiline var first_quest_dialouge: Array[String]

@onready var voice_player: AudioStreamPlayer3D = $"VoicePlayer"
@onready var talking_zone: Area3D = $"TalkingZone"
@onready var door: Door = $"../Door"

func _ready():
	talking_zone.body_entered.connect(tz_player_entered)
	talking_zone.body_exited.connect(tz_player_exited)

	if SaveDataManager.current_save_data.intro_dialouge_played == true:
		door.locked = false

func interact():
	if not SaveDataManager.current_save_data.intro_dialouge_played:
		DialougeManager.start_dialouge(intro_dialouge, "intro_dialouge", play_voice, 0.05)
		DialougeManager.play_dialouge("intro_dialouge")

		if not DialougeManager.get_dialouge("intro_dialouge").on_end.is_connected(on_intro_dialouge_end):
			DialougeManager.get_dialouge("intro_dialouge").on_end.connect(on_intro_dialouge_end)
		return

	if not SaveDataManager.current_save_data.first_quest_dialouge_played:
		DialougeManager.start_dialouge(first_quest_dialouge, "first_quest", play_voice, 0.05)
		DialougeManager.play_dialouge("first_quest")

		if not DialougeManager.get_dialouge("first_quest").on_end.is_connected(on_first_quest_dialouge_end):
			DialougeManager.get_dialouge("first_quest").on_end.connect(on_first_quest_dialouge_end)
		return
	if SaveDataManager.current_save_data.first_quest_dialouge_played == true and not SaveDataManager.current_save_data.first_quest_completed:
		var dialouge = ["Forgot order details? I can repeat."]+first_quest_dialouge
		DialougeManager.start_dialouge(dialouge, "first_quest", play_voice, 0.05)
		DialougeManager.play_dialouge("first_quest")

func play_voice():
	voice_player.pitch_scale = 1 - (randf()-0.5)/5
	voice_player.play()

func on_intro_dialouge_end():
	SaveDataManager.current_save_data.intro_dialouge_played = true
	door.unlock()

func on_first_quest_dialouge_end():
	SaveDataManager.current_save_data.first_quest_dialouge_played = true
	SaveDataManager.current_save_data.first_quest_got_order = true

func tz_player_entered(body):
	if DialougeManager.get_dialouge("intro_dialouge") != null:
		DialougeManager.play_interrupt_dialouge("OK, you are back, let's continue", play_voice, 0.05)

func tz_player_exited(body):
	if DialougeManager.get_dialouge("intro_dialouge") != null:
		DialougeManager.play_interrupt_dialouge("Hey! Where are you going?", play_voice, 0.025, 1, false)
