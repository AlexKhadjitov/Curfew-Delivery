extends Node


var default_step_sound: AudioStream
var glass_step_sound: AudioStream

func get_step_sound(group_name: String) -> AudioStream:
    if group_name == "Glass":
        return glass_step_sound
    return default_step_sound