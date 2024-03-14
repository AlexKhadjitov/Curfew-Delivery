extends CharacterBody3D
class_name Ment

enum State{
    Scanning,
    WakingUp,
    Chasing,
    Returning
}

@export_category("Scanning")
@export var scan_radius: float = 10
@export var crouch_scan_radius: float = 5
@export var run_scan_radius: float = 15
@export var disguised_divisor: float = 1.5

@export_category("Waking up")
@export var wake_up_time: float = 1
var _wakup_time: float = 0

@export_category("Chasing")
@export var speed: float = 5.1
@export var chase_time: float = 20
var _chase_time: float = 0
@export var chase_distance: float = 20

@onready var player: Player
@onready var spawn_point: Node3D = $"../"
@onready var nav_agent: NavigationAgent3D = $"NavigationAgent3D"
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
        if scan_for_player(delta):
            state = State.WakingUp
        
        velocity = Vector3.ZERO
        move_and_slide()
        return

    if state == State.WakingUp:
        #velocity.y = 1/wake_up_time
        _wakup_time += delta

        if _wakup_time >= wake_up_time:
            #velocity.y = 0
            _wakup_time = 0

            if scan_for_player(delta):
                state = State.Chasing
            else:
                state = State.Scanning

        move_and_slide()
        return

    if state == State.Chasing:
        nav_agent.target_position = player.global_position
        var dir
        if not nav_agent.is_navigation_finished():
            dir = nav_agent.get_next_path_position() - global_position
        else:
            dir = Vector3.ZERO
        dir = dir.normalized()
        velocity = dir * speed
        
        if _chase_time >= chase_time:
            _chase_time = 0
            state = State.Returning

        _chase_time += delta
        move_and_slide()
        return

    if state == State.Returning:
        nav_agent.target_position = spawn_point.global_position
        var dir
        if not nav_agent.is_navigation_finished():
            dir = nav_agent.get_next_path_position() - global_position
        else:
            state = State.Scanning
            return
        dir = dir.normalized()
        velocity = dir * speed

        move_and_slide()
        return

func scan_for_player(delta):
    player_dist_checker.target_position = player.global_position - player_dist_checker.global_position
    player_dist_checker.target_position.y += 1
    player_dist_checker.target_position += player.velocity * delta

    var _scan_radius = scan_radius
    if player.state == player.State.Running:
        _scan_radius = run_scan_radius
    elif player.state == player.State.Crouching:
        _scan_radius = crouch_scan_radius
    
    if player.disguised:
        _scan_radius /= 1.5
    
    if player_dist_checker.target_position.length() > _scan_radius:
        return false

    if player_dist_checker.get_collider() == player:
        print("found player")
        return true
    


    return false
