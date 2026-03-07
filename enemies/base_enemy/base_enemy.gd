extends CharacterBody2D
class_name BaseEnemy

enum ActionState {NONE, PATROL, ATTACK, CHASING}
enum LifeState {ALIVE, DEAD} 

@export_group("Enemy Stats")
@export var speed : float = 200
@export var max_life : float = 100 #acho que int aqui seria mais interessante, mas vamos manter o padrao de float por hora
@export var jump_force : float = 200
@export var max_idle_jump_height : float = 20
@export var max_chase_jump_height : float = 40

@export_group("Target Info")
@export var player_path : NodePath

@export_group("Combat")
@export var melee_range : float = 40
@export var ranged_range : float = 200
@export var attack_cooldown : float = 1.5

@export_group("Patrol & Detection")
@export var distance_detection : float = 250
@export var timer_patrol : float = 20
@export var timer_stop : float = 10

@onready var wall_detector := $Sensors/WallDetector
@onready var edge_detector := $Sensors/EdgeDetector
@onready var ground_detector := $Sensors/GroundDetector
@onready var spriteController := $Sprite2D
@onready var distance_sensor := $PlayerDisctanceSensor

var life_state = LifeState.ALIVE
var action_state = ActionState.NONE

var current_player_distance: float
var current_life: float
var direction := 1
var player : CharacterBody2D

var patrol_timer : float = 0.0
var stop_timer : float = 0.0
var attack_timer : float = 0.0

func _ready() -> void:
	current_life = max_life
	
	wall_detector.target_position.x = 82
	edge_detector.target_position.x = 300
	
	player = get_node(player_path)
	distance_sensor.setup(player, distance_detection)

	distance_sensor.player_detected.connect(_on_player_detected)
	distance_sensor.player_lost.connect(_on_player_lost)
	distance_sensor.player_distance.connect(_on_player_distance)
	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980 * delta
	
	match action_state:
		ActionState.NONE:
			print("none")
			idleBehavior()

		ActionState.PATROL:
			print("patrol")
			idleBehavior()

		ActionState.CHASING:
			print("chasing")
			chaseBehavior(delta)

	move_and_slide()
	
func _on_player_detected():
	action_state = ActionState.CHASING

func _on_player_lost():
	action_state = ActionState.PATROL
	patrol_timer = 0

func _on_player_distance(distance):
	current_player_distance = distance

# acredito que seja melhore refatorar isso pra cada inimigo ter seu tipo de ataque apenas. tem que ver
func chooseAttack():
	if attack_timer < attack_cooldown:
		attack_timer += get_physics_process_delta_time()
		print("emCoolDonw")
		return
	print("atacando")
	#arrumar logica de ataques de acordo com tipo de tropa
	
func meleeAttack():

	attack_timer = 0
	action_state = ActionState.ATTACK
	# updateAnimation() # animação de ataque meelee
	print("melee attack")

func rangedAttack():

	attack_timer = 0
	action_state = ActionState.ATTACK
	# updateAnimation() # animação de ataque ranged
	print("ranged attack")

func takeDamage(damage: float) -> void:
	current_life -= damage
	if current_life <= 0:
		die()
	# updateAnimation("") #toca a animação de tomar dano

func idleBehavior() -> void:
	if action_state == ActionState.NONE:
		# updateAnimation("") #toca a animação de idle
		stop_timer += get_physics_process_delta_time()
		velocity.x = 0
		if stop_timer > timer_stop:
			stop_timer = 0
			action_state = ActionState.PATROL
	elif action_state == ActionState.PATROL:
		velocity.x = direction * speed
		if wall_detector.is_colliding():
			print("bateu na parede")
			turnAround()
		# updateAnimation("") #toca a animação de patrol
		patrol_timer += get_physics_process_delta_time()
		if patrol_timer > timer_patrol:
			patrol_timer = 0
			action_state = ActionState.NONE
	
	shouldJump()

func chaseBehavior(delta: float) -> void:
	if current_player_distance > 0:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		chooseAttack()

	shouldJump()
	pass

func shouldJump() -> void: #calcula a distancia do pulo e se faz sentido pular
	if wall_detector.is_colliding():
		var collision = wall_detector.get_collision_point()
		var height = collision.y - global_position.y
		
		if action_state == ActionState.PATROL:
			if abs(height) < max_idle_jump_height:
				jump()
			else:
				turnAround()
		elif action_state == ActionState.CHASING:
			if abs(height) < max_chase_jump_height:
				jump()
			else:
				action_state = ActionState.PATROL

func turnAround():
	direction *= -1
	#scale.x = abs(scale.x) * direction
	wall_detector.target_position.x *= -1
	edge_detector.target_position.x *= -1

func jump():
	if is_on_floor():
		velocity.y = -jump_force

func die():
	life_state = LifeState.DEAD
	current_life = 0 #impede vida negativa
	queue_free()

func updateAnimation(animation: String) -> void:
	spriteController.play(animation)
