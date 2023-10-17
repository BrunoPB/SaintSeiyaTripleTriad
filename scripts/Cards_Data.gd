extends Node

var data_path : String = "res://data/cardsData.json"
var data : Array

func _ready():
	if FileAccess.file_exists(data_path):
		var dataFile = FileAccess.open(data_path,FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		if parsedResult is Array:
			for pr in parsedResult:
				var card : Card = Card.new(
					pr["id"],
					pr["name"],
					pr["image"],
					pr["north"],
					pr["east"],
					pr["south"],
					pr["west"]
				)
				if card is Card:
					data.append(card)
				else:
					push_error("Error reading file")
		else:
			push_error("Error reading file")
	else:
		push_error("File doesn't exist")

func takeRandom(number):
	var deck : Array = []
	var full_data = data.duplicate()
	full_data.shuffle()
	for i in range(0,number):
		deck.append(full_data[i])
	return deck
