extends Area2D

@export var lifetime:float = 1.5

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
