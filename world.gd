extends Node

#@export var map: Array[Array] = []
@export var cmap: Array[String] = []
@export var molar: PackedScene
@export var player: PackedScene
@export var key: PackedScene
@export var blockage: PackedScene
@export var heal: PackedScene
@export var stair_up: PackedScene
@export var stair_down: PackedScene
@export var roof_floor: PackedScene

var Floors: Array[Array]

var Test_Map: Array[String]  = [
	"XXXXXXXX",
	"XOOOOOOX",
	"XOXOXXOX",
	"XOXPOXBX",
	"XOXOOXBX",
	"XOXXOXBX",
	"XOOOOOKX",
	"XXXXXXXX"
]

var L1F1: Array[String]  = [
	"XXXXXXXXXXXXXXXXXX",
	"XXOOXXXXXXXXXXOOXX",
	"XOOOOXXXXXXXXOUKOX",
	"XOOOOBBBBBBBBOOOOX",
	"XXOOXXXXXXXXXXOOXX",
	"XXXOXXXXXXXXXXOXXX",
	"XXXOXXXXXXXXXXOXXX",
	"XXXOXXXXXXXXXXOXXX",
	"XXXOLXXXXXXXXXOXXX",
	"XXXOLXXXXXXXXXOXXX",
	"XXXOXXXXXXXXXXOXXX",
	"XXXOXXXXXXXXXXOXXX",
	"XXXPXXXXXXXXXXOXXX",
	"XXOOXXXXXXXXXXOOXX",
	"XOHOOOOOOOOOOOOUOX",
	"XOKOOXXXXXXXXOOMOX",
	"XXOOXXXXXXXXXXOOXX",
	"XXXXXXXXXXXXXXXXXX",
]

var L1F2: Array[String] = [
	"XXXXXXXXXXXXXXXXXX",
	"XXOOXXXXXXXXXXOOXX",
	"XOKOOXXXXXXXXODOOX",
	"XODOOOOOOOOOOOOOOX",
	"XXOOXXXXXXXXXXOOXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXXBXXXXXXXXXXBXXX",
	"XXBBXXXXXXXXXXOOXX",
	"XBBBBBBBBBBBBOODOX",
	"XBBBBXXXXXXXXOOKOX",
	"XXBBXXXXXXXXXXOOXX",
	"XXXXXXXXXXXXXXXXXX"
]

func load_map(map, offset) -> void:
	var x = -1
	var y = -1
	for row in map:
		x=-1
		y+=1
		for c in row:
			x+=1
			var m = null
			if c == "X": m = molar.instantiate()
			if c == "P": m = player.instantiate(); m.name = "Player"
			if c == "K": m = key.instantiate()
			if c == "B": m = blockage.instantiate()
			if c == "H": m = heal.instantiate()
			if c == "U": m = stair_up.instantiate()
			if c == "D": m = stair_down.instantiate()
			if not (m == null):
				m.position = offset + Vector3(x,0,y)
				add_child(m)
			var r = roof_floor.instantiate()
			r.position = offset + Vector3(x,0,y)
			add_child(r)
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Floors.append(L1F1)
	Floors.append(L1F2)
	load_map(L1F1, Vector3(0,0,0))
	load_map(L1F2, Vector3(0,10,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
