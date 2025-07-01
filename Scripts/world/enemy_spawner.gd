extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_radius: float = 500
@export var spawn_interval: float = 5

var player: Node2D
var timer = 0.0

func set_player(p):
	player = p

func _process(delta):
	if not player:
		print("No player to spawn.")
		return

	timer -= delta
	if timer <= 0:
		spawn_enemy()
		timer = spawn_interval
		
func spawn_enemy():
	if enemy_scenes.is_empty():
		print("No enemies to spawn.")
		return

	var index = randi() % enemy_scenes.size()
	var enemy_scene = enemy_scenes[index]
	var enemy = enemy_scene.instantiate()
	
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_radius
	enemy.global_position = spawn_pos
	
	get_tree().current_scene.add_child(enemy)
