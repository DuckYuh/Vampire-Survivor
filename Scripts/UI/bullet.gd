extends Area2D

@export var speed: float = 300.0
var direction := Vector2.ZERO  # hướng bay mặc định

func _physics_process(delta):
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()  # xóa đạn khi ra khỏi màn hình
