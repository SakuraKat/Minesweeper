extends Node2D

onready var tile_map: TileMap = $TileMap

const IMPOSTER: int = 12
const EXPLODED_MINE: int = 11
const FLAG: int = 9

var number_of_mines: int = 20
var number_of_flags: int = -1
var max_flags: int = 25
var mines = []
var mines_duplicate = []
var numbers = []

func _ready() -> void:
	randomize()
	for _i in range(number_of_mines):
		add_mine()
	for mine in mines:
		for j in range(-1, 2):
			for i in range(-1, 2):
				tile_map.set_cell(mine.x + i, mine.y + j, IMPOSTER)
				if i == 0 and j == 0:
					continue
				var current_position: Vector2 = Vector2(mine.x + i, mine.y + j)
				numbers.append(current_position)
	mines_duplicate = mines.duplicate()

func _process(_delta: float) -> void:
	if mines_duplicate.size() == 0:
		game_won()

func _input(_event: InputEvent) -> void:
	var current_position: Vector2 = (get_global_mouse_position()/ 32).floor()
	
	if Input.is_action_just_released("mouse_left_click"):
		if check_mine(current_position):
			game_over()
		else: 
			clear_adjacent_tiles(current_position)
	if Input.is_action_just_released("mouse_right_click"):
		invert_flag(current_position)

func add_mine() -> void:
	var new_mine: Vector2 = Vector2(randi() % 20, randi() % 20)
	if mines.find(new_mine) == -1:
		mines.append(new_mine)
	else:
		add_mine()

func invert_flag(position: Vector2) -> void:
	if not tile_map.get_cellv(position) == FLAG:
		if number_of_flags < max_flags:
			tile_map.set_cellv(position, FLAG)
			number_of_flags += 1
			if check_mine(position):
				var index = mines_duplicate.find(position)
				mines_duplicate.remove(index)
	else:
		tile_map.set_cellv(position, IMPOSTER)
		if check_mine(position):
			if mines_duplicate.find(position) == -1:
				mines_duplicate.append(position)

func check_mine(position: Vector2) -> bool:
	return false if mines.find(position) == -1 else true

func clear_adjacent_tiles(position: Vector2) -> void:
	if position.x < 0 or position.x > 20 or position.y < 0 or position.y > 20:
		return

	var current_position_value = tile_map.get_cellv(position) 
	
	if current_position_value == -1:
		return
	elif current_position_value == 0:
		tile_map.set_cellv(position, -1)
		for j in range(-1, 2):
			for i in range(-1, 2):
				if i == 0 and j == 0:
					continue
				tile_map.set_cellv(position, -1)
				clear_adjacent_tiles(Vector2(position.x + i, position.y + j))
	else:
		show_number(position)

func show_number(position: Vector2) -> void:
	var current_position_value = 0
	tile_map.set_cellv(position, 11)
	for j in range(-1, 2):
		for i in range(-1, 2):
			var current_position: Vector2 = Vector2(position.x + i, position.y + j)
			for mine in mines:
				if current_position == mine:
					current_position_value += 1
	tile_map.set_cellv(position, current_position_value)

func game_over() -> void:
	for mine in mines_duplicate:
		tile_map.set_cellv(mine, EXPLODED_MINE)

func game_won() -> void:
	print("won")
