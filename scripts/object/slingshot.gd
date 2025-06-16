extends Area2D

@onready var startShot: Marker2D = $gunPivot/texture/shots
@onready var texture: AnimatedSprite2D = $gunPivot/texture
@onready var gunPivot: Node2D = $gunPivot  # Pivô da arma
@onready var player: Node2D = get_parent()  # O player é o nó pai da arma

const BULLET = preload('res://scenes/objects/missile.tscn')

# Distância fixa da arma em relação ao player
const OFFSET_X = 20  # Ajuste conforme necessário

func _ready() -> void:
	texture.play('default')

func _input(event: InputEvent) -> void:
	if Global.ammunation > 0:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				shoot(get_global_mouse_position())  

func shoot(targetPosition: Vector2) -> void:
	Global.ammunation -= 1
	texture.play('shot')
	var newBullet = BULLET.instantiate()
	newBullet.position = startShot.global_position
	newBullet.set_direction(newBullet.position, targetPosition)
	get_tree().root.add_child(newBullet)

func _physics_process(delta: float) -> void:
	var mouse_x = get_global_mouse_position().x
	var pivot_x = player.global_position.x
	
	# Determina se a arma deve ficar à direita ou à esquerda do player
	if mouse_x >= pivot_x:
		gunPivot.position.x = OFFSET_X  # Direita
		texture.flip_h = false  # Mantém a sprite normal
	else:
		gunPivot.position.x = -OFFSET_X  # Esquerda
		texture.flip_h = true  # Espelha a sprite para o lado esquerdo

func _on_texture_animation_finished() -> void:
	if texture.animation == 'shot':
		texture.play('default')
