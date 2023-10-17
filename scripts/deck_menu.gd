extends Node2D

var cards_list : Array = Array()
var deck : Array = Array()
@onready var player = get_node("/root/Player")
var card_base_scene = preload("res://scenes/slot_card_base.tscn")
var card_scene = preload("res://scenes/deck_item.tscn").instantiate()
var target_card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_cards_list()
	build_cards_gui()
	build_deck_gui()

func get_cards_list():
	deck = player.deck
	cards_list = player.cards.filter(func(c): return not deck.has(c))

func build_cards_gui():
	delete_children($"Container/Layout/Scroll Area/Scroll/ScrollOffset/List")
	var n : int = 0
	for card in cards_list:
		var control = Control.new()
		control.name = "CardInList" + str(n)
		var inst = card_scene.duplicate()
		inst.card_data = card
		control.add_child(inst)
		$"Container/Layout/Scroll Area/Scroll/ScrollOffset/List".add_child(control)
		n += 1

func build_deck_gui():
	var card_xpos = 20
	var card_ypos_var = 90
	delete_children($Container/Layout/DeckMargin/DeckArea)
	for i in range(5):
		var card = player.deck[i]
		if card != null:
			var cardGui = card_base_scene.instantiate()
			cardGui.name = card.name
			cardGui.card_data = card
			cardGui.position = Vector2(card_xpos,110 + card_ypos_var)
			$Container/Layout/DeckMargin/DeckArea.add_child(cardGui)
		card_xpos += 66
		card_ypos_var *= -1

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_deck_collision_mouse_exited():
	target_card = null

func putNewCard(card_data):
	if target_card != null:
		var index = player.deck.find(target_card.card_data)
		player.deck[index] = card_data
	get_cards_list()
	build_cards_gui()
	build_deck_gui()
