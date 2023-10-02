extends Node

var turn : bool
var deck : Array
var table : Array = Array()
var cards_data : Cards_Data = Cards_Data.new()
@onready var player_timer = get_node("/root/Game/PlayerTimer") as Timer
@onready var message_timer = get_node("/root/Game/MessageTimer") as Timer
@onready var action_label = get_node("/root/Game/VerticalLayout/Action") as Label
var target_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	startTable()
	startTurn()
	startPlayerDeck()
	startOpponentDeck()

func startTable():
	table = Array()
	for y in range(3):
		var row = Array()
		for x in range(3):
			row.append(null)
		table.append(row)

func startTurn():
	turn = randi_range(0,1) == 0

func startPlayerDeck():
	deck = cards_data.takeRandom(5)

func canPlaceCardAtSlot():
	if not turn or target_slot == null:
		return false
	return table[slot_x(target_slot)][slot_y(target_slot)] == null

func placeCard(card_node):
	var card_info
	for i in range(5):
		var card = deck[i]
		if card != null and card.id == card_node.card_data.id:
			card_info = card
			deck[i] = null
			break
	var x = slot_x(target_slot)
	var y = slot_y(target_slot)
	table[x][y] = {"card":card_info,"owner":0}
	player_timer.stop()
	turn = false
	process_action(x,y,0)

func slot_x(n):
	var x
	if n is int:
		x = n
	else:
		x = int(n.name.substr(4))
	return (x+2) % table.size()
	
func slot_y(n):
	var y
	if n is int:
		y = n
	else:
		y = int(n.name.substr(4))
	return int((y-1) / table.size())

func process_action(x,y,player_index):
	var domined_cards = 0
	# North
	if y - 1 >= 0 and table[x][y-1] != null and table[x][y-1].owner != player_index:
		if table[x][y].card.north > table[x][y-1].card.south:
			table[x][y-1].owner = player_index
			domined_cards += 1
	# East
	if x + 1 < table.size() and table[x+1][y] != null and table[x+1][y].owner != player_index:
		if table[x][y].card.east > table[x+1][y].card.west:
			table[x+1][y].owner = player_index
			domined_cards += 1
	# South
	if y + 1 < table.size() and table[x][y+1] != null and table[x][y+1].owner != player_index:
		if table[x][y].card.south > table[x][y+1].card.north:
			table[x][y+1].owner = player_index
			domined_cards += 1
	# West
	if x - 1 >= 0 and table[x-1][y] != null and table[x-1][y].owner != player_index:
		if table[x][y].card.west > table[x-1][y].card.east:
			table[x-1][y].owner = player_index
			domined_cards += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
#########################################################################################################
#	BOT TESTING ZONE
#########################################################################################################
var opponentDeck : Array = []

func startOpponentDeck():
	opponentDeck = cards_data.takeRandom(5)

func botPlay():
	# Card
	var card = null
	while (card == null):
		card = opponentDeck.pick_random()
	var card_index = opponentDeck.find(card)
	
	# Slot
	var slot_index = null
	while (slot_index == null):
		var rand_index = randi_range(1,9)
		if table[slot_x(rand_index)][slot_y(rand_index)] == null:
			slot_index = rand_index
	
	# Play
	var x = slot_x(slot_index)
	var y = slot_y(slot_index)
	table[x][y] = {"card":card,"owner":1}
	opponentDeck[card_index] = null
	process_action(x,y,1)
