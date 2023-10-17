class_name Card

var id : String
var name : String
var north : int
var east : int
var south : int
var west : int
var file_path : String

func _init(_id:String,_name:String,_file_path:String,_north:int,_east:int,_south:int,_west:int):
	self.id = _id
	self.name = _name
	self.file_path = _file_path
	self.north = _north
	self.east = _east
	self.south = _south
	self.west = _west

func total_power():
	return self.north + self.east + self.south + self.west

func price():
	return total_power()*10
