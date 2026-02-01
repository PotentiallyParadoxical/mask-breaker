extends Area3D
@export var offset: Vector3 = Vector3(0,10,0)
@export var number_offset: int = 1

func _on_body_entered(body: Node3D) -> void:
	if $"../Player".on_stair: return
	$"../Player".on_stair = true
	print("Climb Stairs")
	$"../Player".position += offset
	$"../Player".floor_number += number_offset
