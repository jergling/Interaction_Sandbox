extends Node3D

func _physics_process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Jump pad body emit touched")
	GlobalSignalBus.emit_signal("onJumppadTouched")
