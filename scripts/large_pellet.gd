extends Area2D

class_name LargePellet

signal pellet_eaten()
@export var should_allow_eating_ghosts = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pellet_eaten.emit()
		queue_free()
		if should_allow_eating_ghosts:
			pass
