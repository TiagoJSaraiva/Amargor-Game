extends Node

@export var max_health:float = 100 # Vitalidade do crisol, na lore
@export var max_mana:float = 100; # Vigor de batalha, na lore

var current_health: float
var current_mana: float

func ready() -> void:
	current_health = max_health
	current_mana = max_mana
	add_to_group("player")
	
func take_damage(damage_taken: float) -> void:
	current_health = current_health - damage_taken
	if current_health <= 0:
		current_health = 0
		self.die()
		
func die() -> void:
	# Adicionar função aqui que ativa lógica pós morte.
	queue_free() # Some
	
func attack() -> void:
	print("ataque!")
