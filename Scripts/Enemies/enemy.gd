extends CharacterBody2D

@onready var anin = get_node("AnimatedSprite2D") 
@onready var player = get_node("../Char1")

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	
	if self.position.x > player.position.x:
		anin.play("run")
		anin.scale.x = -1
	else:
		anin.play("run")
		anin.scale.x = 1

	move_and_slide()
