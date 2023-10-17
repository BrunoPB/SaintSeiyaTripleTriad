extends Node

var deck : Array = Array()
var player_name : String
var coins : int = 0
var cards : Array = Array()
@onready var cards_data = get_node("/root/CardsData")

# Called when the node enters the scene tree for the first time.
func _ready():
	startPlayerData()

func startPlayerData():
	player_name = "IKazart"
	deck.append(cards_data.data[5])
	deck.append(cards_data.data[6])
	deck.append(cards_data.data[7])
	deck.append(cards_data.data[1])
	deck.append(cards_data.data[2])
	deck.sort_custom(
		func(c1,c2):
			return c1.price() < c2.price()
	)
	cards.append(cards_data.data[0])
	cards.append_array(deck)
	coins = 100

func buy_card(card:Card):
	if coins >= card.price() && cards.find(card) == -1:
		cards.append(card)
		cards.sort_custom(
			func(c1,c2):
			return c1.price() < c2.price()
		)
		coins -= card.price()

func can_buy(card:Card):
	return coins >= card.price() && cards.find(card) == -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
