extends CharacterBody2D

@onready var anin = get_node("AnimatedSprite2D") 

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var player = get_nearest_player()
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	
	if self.position.x > player.position.x:
		anin.play("run")
		anin.scale.x = -1
	else:
		anin.play("run")
		anin.scale.x = 1

	move_and_slide()

func get_nearest_player() -> Node:
	var players = get_tree().get_nodes_in_group("players")
	var nearest: Node = null

	for p in players:
		nearest = p
	return nearest
