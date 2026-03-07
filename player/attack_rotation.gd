extends Node2D
class_name PlayerNodesBehavior

@onready var sprite = $Sprite

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		self.scale.x = -1
	if event.is_action_pressed("ui_right"):
		self.scale.x = 1
		
