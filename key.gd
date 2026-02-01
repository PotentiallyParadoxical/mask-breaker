extends Area3D

func _on_body_entered(body: Node3D) -> void:
	$"../Control".keys += 1
	print("Key gotten " + str($"../Control".keys) + " owned")
	$"../Control".update_values()
	$"../Player/CollectKey".play()
	self.queue_free()
