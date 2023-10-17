extends PanelContainer

var dragging = false
var can_place = false
var startingPos : Vector2
var game_instance = preload("res://scenes/game.tscn").instantiate()
var slots : Array = getSlots()
var slotSize : Vector2 = Vector2(slots[0].custom_minimum_size.x,slots[0].custom_minimum_size.y)
var slotOffset : Vector2 = Vector2(slots[0].custom_minimum_size.x/2,slots[0].custom_minimum_size.y/2)
var play

func _ready():
	play = get_node("/root/Game").play

func _process(delta):
	if dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_parent().global_position = get_global_mouse_position() - slotOffset
	else:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if dragging and not can_place:
				get_parent().global_position = startingPos
			dragging = false

func _get_drag_data(at_position):
	startingPos = get_parent().global_position
	dragging = true
	can_place = false
	return get_parent()

func _can_drop_data(at_position, data):
	can_place = play.canPlaceCardAtSlot()
	return can_place

func _drop_data(at_position, data):
	play.placeCard(data)

func getSlots():
	return game_instance.get_node("VerticalLayout/Table").get_children()
