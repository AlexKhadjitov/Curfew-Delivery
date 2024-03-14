extends Control
class_name DialougeWindow

var dialouge: Array
var dialouge_id: String
var symbol_speed: float

@onready var label: Label = $"Label"

var is_slide_playing: bool = false
var is_paused: bool = false

var current_slide: int = 0
var slide_skipped: bool = false

signal on_play_voice()
signal on_paused()
signal on_unpaused()
##Emitted, when one slide ends
signal on_slide_end()
##Emitted, when whole dialouge ends
signal on_end()


func play_dialouge():
	if current_slide >= len(dialouge):
		is_slide_playing = false
		end_dialouge()
		return

	await play_slide(dialouge[current_slide])
	
	current_slide += 1

func play_slide(slide_text: String):
	if is_slide_playing:
		label.visible_ratio = 1
		is_slide_playing = false
		slide_skipped = true
		return
	
	is_slide_playing = true
	label.visible_characters = 0
	label.text = slide_text

	for symbol in slide_text:
		if slide_skipped:
			slide_skipped = false
			current_slide -= 1 ##TODO: Change this workaround
			break

		if is_paused:
			await on_unpaused
		
		label.visible_characters += 1
		if not symbol in [" ", ".", ",", ""]:
			on_play_voice.emit()
		await get_tree().create_timer(symbol_speed).timeout
	
	is_slide_playing = false
	on_slide_end.emit()

func pause():
	is_paused = true
	on_paused.emit()
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func unpause():
	is_paused = false
	on_unpaused.emit()
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func end_dialouge():
	DialougeManager.active_dialouges.erase(self)
	on_end.emit()
	queue_free()