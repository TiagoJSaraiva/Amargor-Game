extends Node2D
class_name PlayerDisctanceSensor

signal player_detected
signal player_lost
signal player_distance(distance: float)

var player_inside := false

var distance_detection : float = 0.0
var player_character : CharacterBody2D


func setup(player: CharacterBody2D, detection_distance: float) -> void:
	player_character = player
	distance_detection = detection_distance


func _physics_process(delta: float) -> void:
	player_scan()

func player_scan() -> void:
	if player_character == null:
		return

	var distance := global_position.distance_to(player_character.global_position)
	if distance <= distance_detection and not player_inside:
		player_inside = true
		player_detected.emit()
		player_distance.emit(distance)
	elif distance > distance_detection and player_inside:
		player_inside = false
		player_lost.emit()
