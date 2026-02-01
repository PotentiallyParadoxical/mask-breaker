extends Area3D

func _on_body_entered(body: Node3D) -> void:
	print("HEAL!")
	$"../Control".player["chp"] = $"../Control".player["hp"]
	$"../Control".player["cmp"] = $"../Control".player["mp"]
	$"../Control".update_values()
	$"../Player/Heal".play()
