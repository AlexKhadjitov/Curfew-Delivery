extends Node
class_name Employer


@export_multiline var intro_dialouge: Array[String]

@onready var voice_player: AudioStreamPlayer3D = $"VoicePlayer"
@onready var talking_zone: Area3D = $"TalkingZone"

func _ready():
    talking_zone.body_entered.connect(tz_player_entered)
    talking_zone.body_exited.connect(tz_player_exited)

func interact():
    DialougeManager.start_dialouge(intro_dialouge, "intro_dialouge", play_voice, 0.05)
    DialougeManager.play_dialouge("intro_dialouge")

func play_voice():
    voice_player.play()

func tz_player_entered(body):
    if DialougeManager.get_dialouge("intro_dialouge") != null:
        DialougeManager.play_interrupt_dialouge("OK, you are back, let's continue", play_voice, 0.05)

func tz_player_exited(body):
    if DialougeManager.get_dialouge("intro_dialouge") != null:
        DialougeManager.play_interrupt_dialouge("Hey! Where are you going?", play_voice, 0.025, 1, false)