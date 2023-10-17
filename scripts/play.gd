class_name Play

var turn : bool
var deck : Array
var table : Array = Array()
var cards_data : CardsData
var player_timer : Timer
var action_label : Label
var target_slot = null

# Called when the node enters the scene tree for the first time.
func _init(_deck:Array,_cards_data:CardsData,_player_timer:Timer,_action_label:Label):
	deck = _deck
	cards_data = _cards_data
	player_timer = _player_timer
	action_label = _action_label
	startTable()
	startTurn()
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

func get_game_score():
	var player_score = 0
	var opponent_score = 0
	for y in range(table.size()):
		for x in range(table.size()):
			if table[x][y] == null:
				continue
			if table[x][y].owner == 0:
				player_score += 1
			else:
				opponent_score += 1
	return {
		"player_score" : player_score,
		"opponent_score" : opponent_score
	}

func is_player_game_winner():
	var game_score = get_game_score()
	return game_score.player_score > game_score.opponent_score

func calculate_coins():
	var avg_power = get_average_power_in_table()
	var game_score = get_game_score()
	var multiplier = 1
	if is_player_game_winner():
		multiplier = game_score.player_score
	else:
		multiplier = game_score.opponent_score * -1
	return avg_power * multiplier

func get_average_power_in_table():
	var sum = 0
	for y in range(table.size()):
		for x in range(table.size()):
			if table[x][y] != null:
				sum += table[x][y].card.total_power()
	return sum/((3*3) * 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
#########################################################################################################
#	BOT TESTING ZONE
#########################################################################################################
var opponentDeck : Array = []

func startOpponentDeck():
	var player_deck_avg = 0
	for card in deck:
		player_deck_avg += card.total_power()
	player_deck_avg /= 5
	var pick_up_cards = cards_data.data.duplicate()
	pick_up_cards.shuffle()
	for card in pick_up_cards:
		if card.total_power() <= player_deck_avg + 9:
			opponentDeck.append(card)
		if opponentDeck.size() == 5:
			break

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
