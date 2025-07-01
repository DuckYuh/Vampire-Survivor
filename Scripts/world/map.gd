extends Node2D

var character: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var character_scene = CharacterManager.selected_character
	character = character_scene.instantiate()
	add_child(character)
	character.position = Vector2(100, 100)
	$EnemySpawner.set_player(character)
	$Tilemap.set_player(character)
