extends RayCast3D

@onready var player: Player = $"../../"
@onready var camera = $"../"
@onready var item_holder = $"../ItemHolder"
@onready var grab_point = $"../GrabPoint"

var grab_point_last_pos
var grab_point_v = Vector3.ZERO
var grab_point_speed

var grabbed_obj

func _ready():
	grab_point_last_pos = grab_point.global_position


func _physics_process(delta):
	var object = get_collider()
	#print(object.get_groups())
	if object != null and "Interactables" in object.get_groups():
		print("Interactable")
	
	if object != null and "Pickables" in object.get_groups():
		if Input.is_action_just_pressed("grab"):
			grab_start(object)

	if grabbed_obj != null:
		grab_continue(delta)
		if Input.is_action_just_released("grab"):
			grab_end()

	grab_point_v = (grab_point.global_position - grab_point_last_pos)/delta
	grab_point_speed = grab_point_v.abs().x + grab_point_v.abs().y + grab_point_v.abs().z
	grab_point_last_pos = grab_point.global_position


func grab_start(object):
	grabbed_obj = object

	grabbed_obj.gravity_scale = 0
	grabbed_obj.add_collision_exception_with(player)
	grabbed_obj.linear_velocity = Vector3.ZERO
	grab_point.position.z = -1 * player.global_position.distance_to(grabbed_obj.global_position)
	#print(player.global_position.distance_to(grabbed_obj.global_position))

func grab_continue(delta):
	var motion: Vector3
	motion = grabbed_obj.global_position.direction_to(grab_point.global_position)
	motion *= grabbed_obj.global_position.distance_to(grab_point.global_position)
	motion *= (grab_point_speed + 1)
	#grabbed_obj.move_and_collide(motion)
	grabbed_obj.linear_velocity = motion

	if grabbed_obj.global_position.distance_to(grab_point.global_position) > abs(target_position.z):
		grab_end()

func grab_end():
	grabbed_obj.gravity_scale = 1
	grabbed_obj.remove_collision_exception_with(player)

	grabbed_obj = null