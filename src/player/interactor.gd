extends RayCast3D

@onready var player: Player = $"../../"
@onready var camera = $"../"
@onready var item_holder = $"../ItemHolder"
@onready var grab_point = $"../GrabPoint"

var grabbed_obj


func _physics_process(delta):
	var object = get_collider()
	#print(object.get_groups())
	if object != null and "Interactables" in object.get_groups():
		pass
	
	if object != null and "Pickables" in object.get_groups():
		if Input.is_action_just_pressed("grab"):
			grab_start(object)

	if grabbed_obj != null:
		grab_continue(delta)
		if Input.is_action_just_released("grab"):
			grab_end()


func grab_start(object):
	grabbed_obj = object

	grabbed_obj.gravity_scale = 0
	grabbed_obj.linear_velocity = Vector3.ZERO
	grabbed_obj.add_collision_exception_with(player)
	grabbed_obj.set_axis_lock(56, true)
	
	grab_point.position.z = -1 * camera.global_position.distance_to(grabbed_obj.global_position)
	#print(player.global_position.distance_to(grabbed_obj.global_position))

func grab_continue(delta):
	var motion: Vector3
	motion = grab_point.global_position - grabbed_obj.global_position
	grabbed_obj.linear_velocity = motion * 10 * (grabbed_obj.global_position.distance_to(grab_point.global_position)+1)

	if grabbed_obj.global_position.distance_to(grab_point.global_position) > abs(target_position.z):
		grab_end()

func grab_end():
	grabbed_obj.gravity_scale = 1
	grabbed_obj.linear_velocity /= 2
	grabbed_obj.linear_velocity += player.velocity
	grabbed_obj.remove_collision_exception_with(player)
	grabbed_obj.set_axis_lock(56, false)

	grabbed_obj = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed and grabbed_obj != null:
			grab_point.position.z -= 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed and grabbed_obj != null:
			grab_point.position.z += 0.1
		print(grab_point.position.z)
		grab_point.position.z = clampf(grab_point.position.z, target_position.z, -1)