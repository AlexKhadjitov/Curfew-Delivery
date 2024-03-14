extends Node


var default_step_sound: Array[AudioStream]
var glass_step_sound: AudioStream

func _ready():
    #default_step_sound.append(preload("res://audio/steps/step_cloth1.ogg"))
    default_step_sound.append(preload("res://audio/steps/step_cloth2.ogg"))
    default_step_sound.append(preload("res://audio/steps/step_cloth3.ogg"))
    default_step_sound.append(preload("res://audio/steps/step_cloth4.ogg"))

func get_step_sound(group_name: String) -> AudioStream:
    if group_name == "Glass":
        return glass_step_sound

    return default_step_sound[randi_range(0, len(default_step_sound)-1)]