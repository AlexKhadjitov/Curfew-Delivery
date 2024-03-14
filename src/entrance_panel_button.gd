extends Node

@onready var panel: EntrancePanel = $".."

func interact():
    panel.button_pressed(name)