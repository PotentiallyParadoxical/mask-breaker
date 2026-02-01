extends Node

var hp = 100
var mp = 100
var ehp = 100

var moves: Dictionary ={
	"phys1": {"type": "phys", "name": "Slash", "hp": 3, "mp": 0, "lv": 1, "effect": null},
	"phys2": {"type": "phys", "name": "Rend", "hp": 5, "mp": 0, "lv": 2, "effect": null},
	"phys3": {"type": "phys", "name": "Dismember", "hp": 8, "mp": 0, "lv": 3, "effect": null},
	
	"sang1": {"type": "sang", "name": "Hemolacria", "hp": 3, "mp": 2, "lv": 1, "effect": null},
	"sang2": {"type": "sang", "name": "Hematemesis", "hp": 5, "mp": 3, "lv": 2, "effect": null},
	"sang3": {"type": "sang", "name": "Hemorrhage", "hp": 8, "mp": 3, "lv": 3, "effect": null},
	
	"chol1": {"type": "chol", "name": "Cough", "hp": 0, "mp": 2, "lv": 1, "effect": null},
	"chol2": {"type": "chol", "name": "Vomit", "hp": 0, "mp": 4, "lv": 2, "effect": null},
	"chol3": {"type": "chol", "name": "Sepsis", "hp": 0, "mp": 6, "lv": 3, "effect": null},
	
	"mela1": {"type": "mela", "name": "Tears", "hp": 0, "mp": 2, "lv": 1, "effect": null},
	"mela2": {"type": "mela", "name": "Despair", "hp": 0, "mp": 3, "lv": 2, "effect": null},
	"mela3": {"type": "mela", "name": "Absolute Dejection", "hp": 0, "mp": 4, "lv": 3, "effect": null},
	
	"phle1": {"type": "phle", "name": "Forceful Clot", "hp": -1, "mp": 5, "lv": 1, "effect": null},
	"phle2": {"type": "phle", "name": "Dermal Suture", "hp": -1, "mp": 7, "lv": 2, "effect": null},
	"phle3": {"type": "phle", "name": "Imprecise Transplant", "hp": -1, "mp": 10, "lv": 3, "effect": null},

}

var entities: Dictionary ={
	"rattus1": { "name": "Fleshbound Rodent", "sprite": "", "hp": 7.0, "mp": 0.0, "con": 2, "str": 3, "mag": 0, "moves": ["phys1"], "phys": 1, "sang": 1.25, "chol": 1.25, "mela": 1 }, # Level 1
	"rattus2": { "name": "Fleshbound Rodent", "sprite": "", "hp": 11.0, "mp": 0.0, "con": 3, "str": 5, "mag": 2, "moves": ["phys1", "mela1"], "phys": 1, "sang": 1.25, "chol": 1.25, "mela": 1 }, # Level 2

	"wolf": { "name": "Forlorn Wolf", "sprite": "", "hp": 10.0, "mp": 0.0, "con": 3, "str": 4, "mag": 2, "moves": ["phys1", "mela1"], "phys": 1, "sang": 1.25, "chol": 1, "mela": 0.75 }, # Level 1

	"maid1": { "name": "Forgotten Maid", "sprite": "", "hp": 15.0, "mp": 0.0, "con": 3, "str": 2, "mag": 5, "moves": ["mela1", "chol2"], "phys": 1, "sang": 1.25, "chol": 0.75, "mela": 1.25 }, # Level 2
	"maid2": { "name": "Forgotten Maid", "sprite": "", "hp": 20.0, "mp": 0.0, "con": 4, "str": 2, "mag": 6, "moves": ["mela2", "chol2"], "phys": 1, "sang": 1.25, "chol": 0.75, "mela": 1.25 }, # Level 3

	"noble1": { "name": "Feckless Noble", "sprite": "", "hp": 20.0, "mp": 0.0, "con": 4, "str": 2, "mag": 6, "moves": ["chol2", "sang1"], "phys": 1, "sang": 1.25, "chol": 1.25, "mela": 0 }, # Level 2
	"noble2": { "name": "Feckless Noble", "sprite": "", "hp": 25.0, "mp": 0.0, "con": 4, "str": 2, "mag": 8, "moves": ["chol2", "sang2"], "phys": 1, "sang": 1.25, "chol": 1.25, "mela": 0 }, # Level 3

	"boss1": { "name": "Desecrated Queen of Past Sorrows", "sprite": "", "hp": 60.0, "mp": 0.0, "con": 6, "str": 4, "mag": 8, "moves": ["phys3", "sang2", "chol3", "mela2"], "phys": 0.75, "sang": 1, "chol": 0.75, "mela": 1.25 }, # Level 3

	"boss2": { "name": "Torn Between Ancient Lies", "sprite": "", "hp": 100.0, "mp": 0.0, "con": 7, "str": 8, "mag": 10, "moves": ["phys3", "mela3", "sang3"], "phys": 0.75, "sang": 1, "chol": 0, "mela": 0.75 }, # Level 3

	"player": {"name": "Clair Main", "sprite": "", "hp": 30.0, "mp": 20.0, "con": 4, "str": 5, "mag": 4, "moves": [], "phys": 1, "sang": 1, "chol": 1, "mela": 1 }, # Base stats

}

var masks: Dictionary = {
	"maskphys": {
		"name": "Revolution",
		"moves": [
			["phys1", "mela1", "phle1"], # Moves at level 1
			["phys2", "sang1"], # Add these at level 2
			["phys3"], # And so on
			[] # Empty means no unlocks
		]
	},
	"masksang": {
		"name": "",
		"moves": [
			[], # 1
			[], # 2
			["sang2"], # 3
			["sang3"] #4
		]
	},
	"maskchol": {
		"name": "",
		"moves": [
			["chol1"], # 1
			["chol2"], # 2
			["chol3"], # 3
			[] #4
		]
	},
	"maskmela": {
		"name": "",
		"moves": [
			[], # 1
			["mela2"], # 2
			[], # 3
			["mela3"] #4
		]
	},
	"maskphle": {
		"name": "",
		"moves": [
			[], # 1
			["phle2"], # 2
			[], # 3
			["phle3"] #4
		]
	}
}


func do_move(subject: Dictionary, target: Dictionary, move: Dictionary):
	print("Move Starting HP: " + str(subject['chp']))
	print("Move Starting MP: " + str(subject['cmp']))
	
	var mult = 0.5+move["lv"]*0.25
	if not( move["effect"] == null):
		move["effect"].call(subject, target, move)
	if not move["type"] == "phle":
		var dmg_stat = 0
		if move["type"] == "phys":
			if subject["name"] == "Clair Main":
				if not subject["chp"] > move["hp"]:
					print("Not enough HP!")
					return
				subject["chp"] -= move["hp"]
			dmg_stat = subject["str"]
		else:
			if subject["name"] == "Clair Main":
				if not subject["cmp"] > move["mp"]:
					print("Not enough MP!")
					return
				subject["cmp"] -= move["mp"]
			dmg_stat = subject["mag"]
		var x: float = dmg_stat*mult-0.25*target["con"]
		var d = round(randf_range(1.0,1.2)*x*target[move["type"]])
		print("Damage Dealt: " + str(d))
		target["chp"] -= d
	else:
		if subject["name"] == "Clair Main":
				if not subject["cmp"] > move["mp"]:
					print("Not enough MP!")
					return
				subject["cmp"] -= move["mp"]
		
		var x: float = subject["hp"]/4*subject["mag"]*mult
		var h = min(round(randf_range(1.0,1.2)*x), subject["hp"])
		print("Damage Healt: " + str(h))
		subject["chp"] += h
		if subject["chp"] > subject["hp"]:
			subject["chp"] = subject["hp"]
		subject["cmp"] -= move["mp"]
	
	print("Move Ending HP: " + str(subject['chp']))
	print("Move Ending MP: " + str(subject['cmp']))
