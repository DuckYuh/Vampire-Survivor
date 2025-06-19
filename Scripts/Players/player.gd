extends CharacterBody2D

@onready var anin = get_node("AnimatedSprite2D") 

const SPEED = 200.0

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

	move_and_slide()
