extends PanelContainer

var dragging = false
var can_place = false
var startingPos : Vector2
@onready var card_area_node = get_node("/root/MainMenu/Layout/Content/DeckMenu/Container/Layout/Scroll Area/Scroll/ScrollOffset/List/CardInList0/DeckItem/Container/Layout/CardArea")
var cardOffset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	cardOffset = Vector2(card_area_node.custom_minimum_size.x/2,card_area_node.custom_minimum_size.y/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_parent().global_position = get_global_mouse_position() - cardOffset
	else:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if dragging and not can_place:
				get_parent().global_position = startingPos
			dragging = false
			get_parent().top_level = false

func _get_drag_data(at_position):
	startingPos = get_parent().global_position
	dragging = true
	can_place = false
	get_parent().top_level = true
	return self

func _can_drop_data(at_position, data):
	can_place = get_node("/root/MainMenu/Layout/Content/DeckMenu").target_card != null
	return can_place

func _drop_data(at_position, data):
	get_node("/root/MainMenu/Layout/Content/DeckMenu").putNewCard(data.get_parent().card_data)
