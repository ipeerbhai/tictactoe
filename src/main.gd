extends Control

var board = ["", "", "", "", "", "", "", "", ""]
var current_player = "X"
var is_game_over = false

func _ready():
	var grid_container = get_node_or_null("GridContainer")
	if not grid_container:
		push_error("GridContainer node not found.")
		return
	
	# Connect signals
	for i in range(9):
		var button = grid_container.get_node_or_null("Button" + str(i))
		if not button:
			push_error("Button" + str(i) + " node not found.")
			continue
		button.text = " "  # Initialize button text to ensure visibility
		button.pressed.connect(func(): _on_button_pressed(i))

	initialize_board()
	_initialize_reset_button()

func initialize_board():
	var grid_container = get_node_or_null("GridContainer")
	if not grid_container:
		push_error("GridContainer node not found.")
		return
	for i in range(9):
		var button = grid_container.get_node_or_null("Button" + str(i))
		if button:
			button.text = ""
			button.disabled = false

func _on_button_pressed(index):
	if is_game_over:
		return

	board[index] = current_player
	var grid_container = get_node_or_null("GridContainer")
	if grid_container:
		var button = grid_container.get_node_or_null("Button" + str(index))
		if button:
			button.text = current_player
			button.disabled = true

	if check_win():
		is_game_over = true
		show_game_result(current_player + " wins!")
	elif check_draw():
		is_game_over = true
		show_game_result("It's a draw!")
	else:
		current_player = "O" if current_player == "X" else "X"

func check_win():
	var win_positions = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Horizontal
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Vertical
		[0, 4, 8], [2, 4, 6]             # Diagonal
	]

	for pos in win_positions:
		if board[pos[0]] == current_player and board[pos[1]] == current_player and board[pos[2]] == current_player:
			return true
	return false

func check_draw():
	return "" not in board

func show_game_result(result):
	var result_label = Label.new()
	result_label.name = "ResultLabel"
	result_label.text = result
	result_label.size = Vector2(200, 50)
	if has_node("GridContainer"):
		result_label.position = (get_node("GridContainer").size - result_label.size) / 2
	add_child(result_label)

func _initialize_reset_button():
	var reset_button = get_node_or_null("ResetButton")
	
	if not reset_button:
		push_error("ResetButton node not found.")
		return
	
	reset_button.pressed.connect(_on_reset_button_pressed)

func _on_reset_button_pressed():
	board = ["", "", "", "", "", "", "", "", ""]
	current_player = "X"
	is_game_over = false
	initialize_board()
	
	var result_label = get_node_or_null("ResultLabel")
	if result_label:
		result_label.queue_free()
