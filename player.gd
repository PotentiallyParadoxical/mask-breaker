extends CharacterBody3D

const SPEED = 0.1
const ROT_SPEED = PI/32

var target_pos = Vector3(0,0,0)
var target_rot = 0
var is_moving = false
var floor_number = 0
var on_stair = false
var in_combat = false

func set_in_combat(val: bool) -> void:
	in_combat = val
	
func get_in_combat() -> bool:
	return in_combat

func _ready() -> void:
	target_pos = position

func _process(delta: float) -> void:
	if is_moving: return
	if in_combat: return
	if Input.get_action_strength("move_forward") > 0.5:
		target_pos += Vector3(0,0,-1).rotated(Vector3.UP,target_rot).round()
		var tile_char = get_parent().Floors[floor_number][target_pos.z][target_pos.x]
		if tile_char == "X" or tile_char == "B":
			target_pos -= Vector3(0,0,-1).rotated(Vector3.UP,target_rot).round()
		else:
			is_moving = true
			print("move_forward")
	if Input.get_action_strength("move_right") > 0.5:
		target_rot += -PI/2
		is_moving = true
		print("move_right")
	if Input.get_action_strength("move_left") > 0.5:
		target_rot += PI/2
		is_moving = true
		print("move_left")
	if Input.get_action_strength("move_back") > 0.5:
		#$"../Control".spawn_enemy()
		#in_combat = true
		target_rot += PI
		is_moving = true
		print("move_back")
	if Input.get_action_strength("Spawn") > 0.5:
		$"../Control".spawn_enemy()
		in_combat = true
		

func _physics_process(delta: float) -> void:
	position.x = move_toward(position.x, target_pos.x, SPEED)
	position.z = move_toward(position.z, target_pos.z, SPEED)
	rotation.y = move_toward(rotation.y, target_rot, ROT_SPEED)
	
	if abs(position.x - target_pos.x)>0.01: return
	if abs(position.z - target_pos.z)>0.01: return
	if abs(rotation.y - target_rot)>0.1: return
	if randf() >= 0.95 and is_moving:
		$"../Control".spawn_enemy()
		in_combat = true
	is_moving = false
	on_stair = false
