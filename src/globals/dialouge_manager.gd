extends Node

@onready var dialouge_window = preload("res://src/ui/dialouge_window.tscn")

##Array containing all actvie DialougeWindow
##It is array, altough this code clearly doesn't support multuple of them :)
var active_dialouges: Array[DialougeWindow] = []


func get_dialouge(dialouge_id) -> DialougeWindow:
	for child in get_children():
		if child.dialouge_id == dialouge_id:
			return child
	return null

func start_dialouge(dialouge: Array[String], dialouge_id = "", on_play_voice = null, symbol_speed = 0.05):
	if get_dialouge(dialouge_id) != null:
		return

	var dw_instance = dialouge_window.instantiate()
	active_dialouges.append(dw_instance)

	dw_instance.dialouge = dialouge
	dw_instance.dialouge_id = dialouge_id
	dw_instance.name = dialouge_id
	dw_instance.symbol_speed = symbol_speed

	if on_play_voice != null:
		dw_instance.on_play_voice.connect(on_play_voice)

	add_child(dw_instance)
	return dw_instance

func play_interrupt_dialouge(dialouge: String, on_play_voice: Callable, symbol_speed: float = 0.05, visible_time: float = 1, unpause: bool = true):
	var prev_idw = get_dialouge("interrupt_dialouge")
	if prev_idw != null:
		prev_idw.queue_free()
		active_dialouges.erase(prev_idw)
	
	var idw_instance: DialougeWindow = start_dialouge([dialouge], "interrupt_dialouge", on_play_voice, symbol_speed)

	for dw_instance in active_dialouges:
		if dw_instance != idw_instance:
			dw_instance.pause()

	idw_instance.play_dialouge()
	await idw_instance.on_slide_end
	await get_tree().create_timer(visible_time).timeout
	idw_instance.end_dialouge()

	for dw_instance in active_dialouges:
		if dw_instance != idw_instance and unpause:
			dw_instance.unpause()
	
func play_dialouge(dialouge_id):
	var dw_instance: DialougeWindow = get_dialouge(dialouge_id)
	if dw_instance == null:
		return
	
	dw_instance.play_dialouge()
	
