extends Node
class_name EntrancePanel

@onready var label: Label3D = $"Label3D"
@onready var door: Door = $"../"

@onready var sound_player: AudioStreamPlayer3D = $"AudioStreamPlayer3D"
@onready var press_sound: AudioStream = preload("res://audio/entrance_panel/press.mp3")
@onready var accept_sound: AudioStream = preload("res://audio/entrance_panel/accept.mp3")
@onready var reject_sound: AudioStream = preload("res://audio/entrance_panel/reject.mp3")

@export var code: String

func _ready():
    label.text = ""

func button_pressed(button: String):
    if len(label.text) < 3:
        label.text += button
        sound_player.stream = press_sound
        sound_player.play()
        return

    if len(label.text) == 3:
        activate(label.text)
        label.text = ""
    
func activate(_code: String):
    if code == _code:
        sound_player.stream = accept_sound
        sound_player.play()
        door.unlock()
        return
    sound_player.stream = reject_sound
    sound_player.play()
