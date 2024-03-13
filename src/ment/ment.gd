extends CharacterBody3D
class_name Ment

enum State{
    Scanning,
    WakingUp,
    Chasing
}

@export_category("Scanning")
@export var scan_radius: float = 10
@export var crouch_scan_radius: float = 5
@export var run_scan_radius: float = 15
@export var disguised_divisor: float = 1.5

@export_category("Waking up")
@export var wake_up_time: float = 1
@onready var _wakup_time: float = 0

@export_category("Chasing")
@export var speed: float = 6

@onready var player: Player
@onready var spawn_point: Node3D = $"../"
@onready var nav_agent: NavigationAgent3D = $"NavigationAgent3D"
@onready var debug_sphere: Node3D = $"DebugSphere"
@onready var player_dist_checker: RayCast3D = $"PlayerDistanceChecker"


var state: State = State.Scanning

func _ready():
    get_player.call_deferred()
    

func get_player():
    player = get_tree().get_nodes_in_group("Player")[0]


func _physics_process(delta):
    if player == null:
        return

    if state == State.Scanning:
        if scan_for_player():
            state = State.WakingUp
        
        #velocity.y = -1/wake_up_time
        move_and_slide()
        return

    if state == State.WakingUp:
        #velocity.y = 1/wake_up_time
        _wakup_time += delta

        if _wakup_time >= wake_up_time:
            #velocity.y = 0
            _wakup_time = 0
            if scan_for_player():
                state = State.Chasing
            else:
                state = State.Scanning

        move_and_slide()
        return

    if state == State.Chasing:
        nav_agent.target_position = player.global_position
        var dir = nav_agent.get_next_path_position() - global_position

        dir = dir.normalized()
        #var dir_delta = (dir - last_dir).length()
        #print(dir_delta)
        set_debug_sphere(dir)

        velocity = dir * speed
        #if dir_delta >= 0.4:
        #    velocity = -1 * (global_position - player.global_position) * 10
        #    pass

        #velocity.y = 0
        move_and_slide()
        #last_dir = dir
        return

func scan_for_player():
    player_dist_checker.target_position = player.global_position - player_dist_checker.global_position
    player_dist_checker.target_position.y += 1

    var _scan_radius = scan_radius
    if player.state == player.State.Running:
        _scan_radius = run_scan_radius
    elif player.state == player.State.Crouching:
        _scan_radius = crouch_scan_radius
    
    if player.disguised:
        _scan_radius /= 1.5
    
    if player_dist_checker.get_collider() == player and player_dist_checker.target_position.length() <= _scan_radius:
        print("found player")
        return true
    return false


func set_debug_sphere(dir):
    debug_sphere.position.x = dir.x
    debug_sphere.position.z = dir.z
    debug_sphere.position.y = dir.y + 1