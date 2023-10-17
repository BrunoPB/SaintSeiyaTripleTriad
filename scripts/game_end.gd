extends CanvasLayer

var text
var text_theme
var coins
var coins_variation : int
var player_winner
var player_score
var opponent_score
var play
var force_loss = false
@onready var player = get_node("/root/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	start_vars()
	build_gui()
	$Layout/Bottom/BottomLayout/CoinsContainer/CoinsAnim.play()

func start_vars():
	play = get_node("/root/Game").play
	if force_loss:
		player_score = 0
		opponent_score = 0
		coins = -150
		text = "DEFEAT"
		text_theme = load("res://themes/defeat_font.tres")
		return
	var scoreboard = play.get_game_score()
	player_score = scoreboard.player_score
	opponent_score = scoreboard.opponent_score
	if play.is_player_game_winner():
		text = "VICTORY!"
		text_theme = load("res://themes/victory_font.tres")
	else:
		text = "DEFEAT"
		text_theme = load("res://themes/defeat_font.tres")
	coins = play.calculate_coins()

func build_gui():
	var title_label = $Layout/TitleContainer/Title
	var player_score_label = $Layout/Bottom/BottomLayout/ScoreContainer/ScoreLayout/PlayerScore
	var opponent_score_label = $Layout/Bottom/BottomLayout/ScoreContainer/ScoreLayout/OpponentScore
	var coins_label = $Layout/Bottom/BottomLayout/CoinsContainer/PanelContainer/NumberOfCoins
	title_label.text = text
	title_label.theme = text_theme
	player_score_label.text = str(player_score)
	opponent_score_label.text = str(opponent_score)
	var victory_theme = player_score_label.theme.duplicate()
	var defeat_theme = victory_theme.duplicate()
	if play.is_player_game_winner():
		victory_theme.set_font_size("font_size","Label",(player_score*5)+20)
		victory_theme.set_color("font_color","Label",Color.GREEN)
		defeat_theme.set_font_size("font_size","Label",(opponent_score*5)+20)
		defeat_theme.set_color("font_color","Label",Color.RED)
		player_score_label.theme = victory_theme
		opponent_score_label.theme = defeat_theme
	else:
		defeat_theme.set_font_size("font_size","Label",(player_score*5)+20)
		defeat_theme.set_color("font_color","Label",Color.GREEN)
		victory_theme.set_font_size("font_size","Label",(opponent_score*5)+20)
		victory_theme.set_color("font_color","Label",Color.RED)
		player_score_label.theme = defeat_theme
		opponent_score_label.theme = victory_theme
	if coins < 0:
		coins_label.text = "- "
		if player.coins < abs(coins):
			coins_variation = player.coins * -1
		else:
			coins_variation = coins
	else:
		coins_label.text = "+ "
		coins_variation = coins
	coins_label.text += str(abs(coins_variation))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ok_button_pressed():
	get_tree().paused = false
	player.coins += coins_variation
	var menu_packed = preload("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(menu_packed)
	queue_free()
