extends TileMapLayer

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()


const CHUNK_SIZE = 64  # Number of tiles per chunk (width & height)
const TILE_SIZE = 16  # Each tile’s size in pixels

const GRASS_TILES = Vector2(0, 0)
const ROCK_TILE = Vector2(8, 8)
const WATER_TILE = Vector2(0, 8)

@onready var player: CharacterBody2D

var generated_chunks = {}  # Keeps track of generated chunks
var chunk_queue = []  # Chunks waiting to be generated

func _ready():
	_initialize_noise()
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			generate_chunk(Vector2i(dx, dy))

func _physics_process(_delta):
	check_chunk_loading()  # Check if we need a new chunk
	process_chunk_queue()  # Process chunks gradually

func _initialize_noise():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
func set_player(p):
	player = p
	if player:
		print("add player")

func generate_chunk(chunk_pos: Vector2i):
	if chunk_pos in generated_chunks:
		return  # Skip if chunk already exists
	generated_chunks[chunk_pos] = true
	chunk_queue.append(chunk_pos)  # Add to queue for processing

func process_chunk_queue():
	if chunk_queue.is_empty():
		return

	var chunk_pos = chunk_queue.pop_front()
	var chunk_offset = chunk_pos * CHUNK_SIZE  # Convert to world coordinates
	
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var world_x = chunk_offset.x + x
			var world_y = chunk_offset.y + y

			# Generate terrain based on noise
			var alt = altitude.get_noise_2d(world_x, world_y) * 10
			var moist = moisture.get_noise_2d(world_x, world_y) * 10

			var atlas_coords: Vector2
			if alt < 2 and moist > 4:
				atlas_coords = WATER_TILE
			elif alt > 4 and moist < 2:
				atlas_coords = ROCK_TILE
			else:
				atlas_coords = GRASS_TILES

			set_cell(Vector2i(world_x, world_y), 0, atlas_coords)

func check_chunk_loading():
	if not is_instance_valid(player):
		return
	var player_chunk = Vector2i(
		floor(player.global_position.x / (CHUNK_SIZE * TILE_SIZE)),
		floor(player.global_position.y / (CHUNK_SIZE * TILE_SIZE))
	)
	
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var offset = Vector2i(dx, dy)
			var chunk_pos = player_chunk + offset
			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)
