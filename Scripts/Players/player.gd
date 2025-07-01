extends CharacterBody2D

@onready var camera = $Camera2D
@onready var anin = get_node("AnimatedSprite2D") 
@onready var bullet1 = preload("res://Scences/UI/char_1_attack.tscn")
@onready var bullet2 = preload("res://Scences/UI/char_2_attack.tscn")
@onready var bullet3 = preload("res://Scences/UI/char_3_attack.tscn")
@onready var bullet4 = preload("res://Scences/UI/char_4_attack.tscn")

const SPEED = 200.0
const SHOOT_INTERVAL = 2
var shoot_timer = 2

func _ready():
	camera.make_current()

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	var direction_lr := Input.get_axis("ui_left", "ui_right")
	var direction_ud := Input.get_axis("ui_down", "ui_up")
	
	if direction_lr:
		anin.play("run")
		anin.scale.x = direction_lr
	elif direction_ud and direction_lr:
		anin.play("run")
		anin.scale.x = direction_lr
	elif direction_ud:
		anin.play("run")
	else:
		anin.play("idle")

	velocity = input_vector * SPEED
	
	shoot_timer -= delta
	
	if shoot_timer <= 0:
		shoot_at_enemy()
		shoot_timer = SHOOT_INTERVAL

	move_and_slide()
	
func get_nearest_enemy() -> Node:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: Node = null
	var min_dist = INF

	for e in enemies:
		var dist = global_position.distance_to(e.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = e
	return nearest

func shoot_at_enemy():
	var target = get_nearest_enemy()
	if not target:
		return
	
	var bullet = bullet1.instantiate()
	bullet.position = global_position

	var direction = (target.global_position - global_position).normalized()
	bullet.direction = direction
	bullet.rotation = direction.angle()

	get_tree().current_scene.add_child(bullet)
