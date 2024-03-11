extends Node


@onready var prop_body: RigidBody3D = $"../"
@export var break_speed: float = 5

func _ready():
    prop_body.contact_monitor = true
    prop_body.max_contacts_reported = 1
    prop_body.body_entered.connect(body_entered)

func body_entered(body):
    if prop_body.linear_velocity.length() >= break_speed:
        await get_tree().create_timer(1)
        #prop_body.queue_free()