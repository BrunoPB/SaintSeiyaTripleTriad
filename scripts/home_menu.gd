extends Node2D

@onready var player = get_node("/root/Player")
const tableCardBase = preload("res://scenes/static_card_base.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_gui()

func start_gui():
	var card_xpos = 20
	var card_ypos_var = 90
	delete_children($Container/VBoxContainer/DeckMargin/DeckArea)
	for i in range(5):
		var card = player.deck[i]
		if card != null:
			var cardGui = tableCardBase.instantiate()
			cardGui.name = card.name
			cardGui.card_data = card
			cardGui.position = Vector2(card_xpos,110 + card_ypos_var)
			$Container/VBoxContainer/DeckMargin/DeckArea.add_child(cardGui)
		card_xpos += 66
		card_ypos_var *= -1

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
''
func _on_play_button_pressed():
	var game_packed = preload("res://scenes/game.tscn")
	get_tree().change_scene_to_packed(game_packed)
	queue_free()
