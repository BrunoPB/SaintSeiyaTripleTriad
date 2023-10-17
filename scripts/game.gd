extends Control

var play
@onready var player = get_node("/root/Player")
@onready var cards_data = get_node("/root/CardsData")
@onready var player_timer = $PlayerTimer as Timer
@onready var action_label = $VerticalLayout/Action as Label
const deckCardBase = preload("res://scenes/drag_card_base.tscn")
const tableCardBase = preload("res://scenes/static_card_base.tscn")
const pause_screen = preload("res://scenes/pause.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	play = Play.new(player.deck.duplicate(),cards_data,player_timer,action_label)
	buildDeckGui()
	buildTableGui()
	game()

func buildDeckGui():
	var card_xpos = 10
	var card_ypos_var = 48
	var zindexes = [1,2,3,2,1]
	var zindex_counter = 0
	delete_children($VerticalLayout/DeckArea)
	for i in range(5):
		var card = play.deck[i]
		if card != null:
			var cardGui = deckCardBase.instantiate()
			cardGui.name = card.name
			cardGui.card_data = card
			cardGui.z_index = zindexes[zindex_counter]
			cardGui.position = Vector2(card_xpos,60 + card_ypos_var)
			$VerticalLayout/DeckArea.add_child(cardGui)
		zindex_counter += 1
		card_xpos += 72
		card_ypos_var *= -1

func buildTableGui():
	var slot_counter = 0
	for y in range(play.table.size()):
		for x in range(play.table[y].size()):
			var slot = play.table[x][y]
			if slot == null:
				slot_counter += 1
				continue
			else:
				var cardGui = tableCardBase.instantiate()
				var card = slot.card
				cardGui.name = card.name
				cardGui.card_data = card
				cardGui.position = Vector2(4,4)
				$VerticalLayout/Table.get_child(slot_counter).add_child(cardGui)
				var sTheme
				if slot.owner == 0:
					sTheme = load("res://themes/table_slot_owner.tres")
				else:
					sTheme = load("res://themes/table_slot_opponent.tres")
				$VerticalLayout/Table.get_child(slot_counter).theme = sTheme
				slot_counter += 1

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func gameEnded():
	var number_of_cards_in_deck = play.deck.filter(func(c): return c != null).size()
	var number_of_cards_in_opponent_deck = play.opponentDeck.filter(func(c): return c != null).size()
	if  number_of_cards_in_deck == 0:
		return true
	if number_of_cards_in_opponent_deck == 0:
		return true
	for slot in play.table:
		if slot.has(null):
			return false
	return true

func game():
	while(not gameEnded()):
		if play.turn:
			var time = 30
			$PlayerTimer.start(time)
			while(time > 0 and not $PlayerTimer.is_stopped()):
				$VerticalLayout/Action.text = "YOUR TURN (" + str(int(time)) + ")"
				$AuxTimer.start(0.1)
				await $AuxTimer.timeout
				time -= 0.1
			play.turn = false
		else:
			$VerticalLayout/Action.text = "OPPONENT TURN"
			$AuxTimer.start(2)
			await $AuxTimer.timeout
			play.botPlay()
			play.turn = true
		buildDeckGui()
		buildTableGui()
	call_game_end_screen()

func call_game_end_screen():
	var game_end = load("res://scenes/game_end.tscn").instantiate()
	add_child(game_end)

func _on_pause_button_pressed():
	var pause_scene = pause_screen.instantiate()
	add_child(pause_scene)
