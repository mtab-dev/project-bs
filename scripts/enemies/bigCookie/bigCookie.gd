extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $animation
@onready var canvasForBar: CanvasLayer = $canvasBar
@onready var healthBar: ProgressBar = $canvasBar/HealthBar
@onready var entryRoom: AudioStreamPlayer2D = $enterBoss
@onready var bossDamage: AudioStreamPlayer2D = $bossDamage
@onready var afterDeath: AudioStreamPlayer2D = $killDeath
var isPlayerInDetectionArea: bool = false  # Controla se o jogador está na área de detecção
var health = 20
var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health = 20
	healthBar.initHealth(health)

func _physics_process(delta):
	if velocity.x > 0:
		animation.flip_h = false
	else:
		animation.flip_h = true
	move_and_slide()

func _process(delta: float) -> void:
	if health <= 10:
		Global.madCookie = true
	else:
		Global.madCookie = false

func _on_detection_area_body_entered(body):
	if not Global.isDead and body.is_in_group('Player'):
		isPlayerInDetectionArea = true 
		animation.play('whiteAttack')

func _on_detection_area_body_exited(body):
	if body.is_in_group('Player'):
		isPlayerInDetectionArea = false

func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('Bullets'):
		bossDamage.play()
		health -= 1
		healthBar.health = health  
		if health <= 0:
			Global.deadCookie = true
			queue_free()

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		entryRoom.play()
		canvasForBar.visible = true

func _on_enemy_area_exited_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		canvasForBar.visible = false

func _on_kill_death_finished() -> void:
	queue_free()

func hitWhenAnim():
	if isPlayerInDetectionArea:
		Global.life -= 1

func _on_animation_animation_finished() -> void:
	hitWhenAnim()
