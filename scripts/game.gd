extends Control

@onready var play = get_node("/root/Play")
const deckCardBase = preload("res://scenes/deck_card_base.tscn")
const tableCardBase = preload("res://scenes/table_card_base.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	for slot in play.table:
		if slot.has(null):
			return false
	return true

func game():
	while(not gameEnded()):
		if play.turn:
			var time = 30
			$PlayerTimer.start(30)
			while(time > 0 and not $PlayerTimer.is_stopped()):
				$VerticalLayout/Action.text = "YOUR TURN (" + str(int(time)) + ")"
				await get_tree().create_timer(0.1).timeout
				time -= 0.1
			play.turn = false
		else:
			$VerticalLayout/Action.text = "OPPONENT TURN"
			await get_tree().create_timer(2).timeout
			play.botPlay()
			play.turn = true
		buildDeckGui()
		buildTableGui()
	# Overlay message : victory or defeat
