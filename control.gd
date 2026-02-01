extends Control

@export var is_ui_shown = true
@export var keys = 0

var player = {}
var enemy = null
var mask_index: int = 0
var mask_count = 0
var mask = null
var level = 3

# *****DOUBLED***** here for easier integer math
var player_turns = 4
var enemy_turns = 2
var cplayer_turns = player_turns
var cenemy_turns = enemy_turns

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mask_count = $Data.masks.keys().size()
	mask = $Data.masks.keys()[mask_index]
	$Portrait/Mask.texture = load($Data.masks[mask]["sprite"])
	player = $"Data".entities["player"].duplicate(true)
	player["chp"] = player["hp"]
	player["cmp"] = player["mp"]
	$"List of Magiks".visible = false
	$"Assortment of Attacks".visible = false
	$"Bag of the Items".visible = false
	$"Top Bar".visible = false
	$Eturn.visible = false
	$Pturn.visible = false
	#$Mask.visible = false
	#$Attack.visible = false
	$"List of Magiks".focus_mode = FOCUS_NONE
	$"Bag of the Items".focus_mode = FOCUS_NONE
	$"Assortment of Attacks".focus_mode = FOCUS_NONE
	update_values()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_values():
	# Get enemy values
	var echp: float = 100
	var ehp: float = 100
	if enemy:
		echp = enemy["chp"]
		ehp = enemy["hp"]
	# Remove existing moves in menus
	$"Assortment of Attacks".clear()
	$"List of Magiks".clear()
	# Get player moveset
	var moves = []
	moves.append_array(player["moves"])
	for i in range(level):
		moves.append_array($Data.masks[mask]["moves"][i])
	# Repopulate menu
	for i in moves:
		var m = $Data.moves[i]
		if m["type"] == "phys":
			$"Assortment of Attacks".add_item(m["name"])
		else:
			$"List of Magiks".add_item(m["name"])
	# Set bars and labels
	$"health holder/health/health content".position = Vector2(-71,71).lerp(Vector2.ZERO, min(1,player["chp"]/player["hp"]))
	$"mana holder/mana/mana content".position = Vector2(-71,71).lerp(Vector2.ZERO, min(1,player["cmp"]/(player["mp"])))
	$"Top Bar/enemy health holder/ehealth/ehealth content".position = Vector2(-71,71).lerp(Vector2.ZERO, min(1,echp/ehp))
	$"Bag of the Items".set_item_text(0, "Keys: " + str(keys))
	# Press turn system
	$Pturn/HT1.visible = cplayer_turns % 2 == 1
	$Pturn/T1.visible = cplayer_turns >= 2 and cplayer_turns % 2 == 0
	$Pturn/T2.visible = cplayer_turns >= 3
	$Pturn/T3.visible = cplayer_turns >= 5
	$Pturn/T4.visible = cplayer_turns >= 7
	# ---
	$Eturn/HT1.visible = cenemy_turns % 2 == 1
	$Eturn/T1.visible = cenemy_turns >= 2 and cenemy_turns % 2 == 0
	$Eturn/T2.visible = cenemy_turns >= 3
	$Eturn/T3.visible = cenemy_turns >= 5
	$Eturn/T4.visible = cenemy_turns >= 7

func do_attack(move: String) -> void:
	# Nothing to do!
	# TODO: Please add printing for this :3
	if enemy == null: return
	if cplayer_turns <= 0: return
	
	# Use selected player's turn!
	print(player["name"] + " uses " + $Data.moves[move]["name"])
	$Data.do_move(player,enemy,$Data.moves[move])
	update_values()
	
	var type = $Data.moves[move]["type"] # Get move type
	
	if not type == "phle":
		var enemy_res = enemy[type] # Fetch resistance
		print(enemy["name"] + " has resistance " + str(enemy_res))
		
		# Update press turns accordingly
		if enemy_res == 1.25: cplayer_turns -= 1
		elif enemy_res == 0: cplayer_turns = 0
		else: cplayer_turns -= 2
	else: cplayer_turns -= 2
	update_values()
	print("Player press turns: " + str(cplayer_turns))
	
	# React to death
	if enemy["chp"]<=0:
		# Reset press turns and move on
		cplayer_turns = player_turns
		cenemy_turns = enemy_turns
		update_values()
		return
	if player["chp"]<=0: get_tree().quit()
	
	# If the player expended the last of their turns, go forth and rattus the playus
	if cplayer_turns <= 0:
		do_enemy_attack()

# Enemy turnio
# Does all enemy turns in one then resets press turns and hands control back to player
func do_enemy_attack() -> void:
	while true:
		if cenemy_turns <= 0: break

		var enemy_move = enemy["moves"][randi_range(0,enemy["moves"].size()-1)]
		
		print(enemy["name"] + " uses " + $Data.moves[enemy_move]["name"])
		$Data.do_move(enemy,player,$Data.moves[enemy_move])
		update_values()
		
		var type = $Data.moves[enemy_move]["type"] # Get move type
		
		if not type == "phle":
			var player_res = player[type] # Fetch resistance
			print(player["name"] + " has resistance " + str(player_res))
			
			# Update press turns accordingly
			if player_res == 1.25: cenemy_turns -= 1
			elif player_res == 0: cenemy_turns = 0
			else: cenemy_turns -= 2
		else: cenemy_turns -= 2
		
		print("Enemy press turns: " + str(cenemy_turns))
		
		if player["chp"]<=0: get_tree().quit() # KILL KILL KILL KILL
	
	# Reset press turns and move on
	cplayer_turns = player_turns
	cenemy_turns = enemy_turns
	update_values()

func _input(event: InputEvent) -> void:
	#if Input.get_action_strength("move_back") > 0.5:
		#is_ui_shown = not is_ui_shown
		#if not is_ui_shown:
			#$CombatHUD.scale = Vector2(1,2)
			#$CombatHUD.position = Vector2(0,-240)
			#$"List of Magiks".visible = false
			#$"Assortment of Attacks".visible = false
			#$"Bag of the Items".visible = false
		#else:
			#$CombatHUD.scale = Vector2(1,1)
			#$CombatHUD.position = Vector2(0,0)
	if event.is_action_released("Magic"):
		if $"List of Magiks".visible == true:
			for i in $"List of Magiks".get_selected_items():
				$"List of Magiks".deselect(i)
				var text = $"List of Magiks".get_item_text(i)
				var id = ""
				for j in $Data.moves.keys():
					if $Data.moves[j].name == text: id=j; break
				do_attack(id)
		$"List of Magiks".visible = not $"List of Magiks".visible
		
		if $"List of Magiks".visible:
			$"Assortment of Attacks".visible = false
			$"Bag of the Items".visible = false
			$"List of Magiks".focus_mode = FOCUS_ALL
			$"Bag of the Items".focus_mode = FOCUS_NONE
			$"Assortment of Attacks".focus_mode = FOCUS_NONE
			$"List of Magiks".grab_focus()
			$"List of Magiks".select(0, true)
	if event.is_action_released("Attack"):
		if $"Assortment of Attacks".visible == true:
			for i in $"Assortment of Attacks".get_selected_items():
				$"Assortment of Attacks".deselect(i)
				var text = $"Assortment of Attacks".get_item_text(i)
				var id = ""
				for j in $Data.moves.keys():
					if $Data.moves[j].name == text: id=j; break
				do_attack(id)
		$"Assortment of Attacks".visible = not $"Assortment of Attacks".visible
		if $"Assortment of Attacks".visible:
			$"Bag of the Items".visible = false
			$"List of Magiks".visible = false
			$"List of Magiks".focus_mode = FOCUS_NONE
			$"Bag of the Items".focus_mode = FOCUS_NONE
			$"Assortment of Attacks".focus_mode = FOCUS_ALL
			$"Assortment of Attacks".grab_focus()
			$"Assortment of Attacks".select(0, true)
	if event.is_action_released("Item"):
		if $"Bag of the Items".visible == true:
			for i in $"Bag of the Items".get_selected_items():
				$"Bag of the Items".deselect(i)
				var text = $"Bag of the Items".get_item_text(i)
				if text == "Quit Button":
					get_tree().quit()
		$"Bag of the Items".visible = not $"Bag of the Items".visible
		if $"Bag of the Items".visible:
			$"Assortment of Attacks".visible = false
			$"List of Magiks".visible = false
			$"List of Magiks".focus_mode = FOCUS_NONE
			$"Bag of the Items".focus_mode = FOCUS_ALL
			$"Assortment of Attacks".focus_mode = FOCUS_NONE
			$"Bag of the Items".grab_focus()
			$"Bag of the Items".select(0, true)
	
	# Set buttons to correct state
	$Mask.set_pressed($"List of Magiks".visible)
	$Bag.set_pressed($"Bag of the Items".visible)
	$Attack.set_pressed($"Assortment of Attacks".visible)
	
	if not enemy == null and enemy["chp"] <= 0:
		$"../Player".in_combat = false
		$Enemy.visible = false
		$"Top Bar".visible = false
		$Eturn.visible = false
		$Pturn.visible = false
		#$Mask.visible = false
		#$Attack.visible = false
		enemy = null
	if player["chp"] <= 0: get_tree().quit()
	
	if event.is_action_released("Help"):
		if $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.stop()
			$VideoStreamPlayer.visible = false
		else:
			$VideoStreamPlayer.play()
			$VideoStreamPlayer.visible = true
			
	if event.is_action_released("move_left") and $"../Player".get_in_combat():
		if mask_index == 0: mask_index = mask_count
		mask_index -= 1
	
		mask = $Data.masks.keys()[mask_index]
		$Portrait/Mask.texture = load($Data.masks[mask]["sprite"])
		
	if event.is_action_released("move_right") and $"../Player".get_in_combat():
		mask_index += 1
		if mask_index == mask_count: mask_index = 0
	
		mask = $Data.masks.keys()[mask_index]
		$Portrait/Mask.texture = load($Data.masks[mask]["sprite"])
		
	update_values()

func spawn_enemy() -> void:
	enemy = $"Data".entities["rattus1"].duplicate(true)
	enemy["chp"] = enemy["hp"]
	enemy["cmp"] = enemy["mp"]
	$Enemy.visible = true
	$"Top Bar".visible = true
	$Eturn.visible = true
	$Pturn.visible = true
	#$Mask.visible = true
	#$Attack.visible = true
	$Enemy/Hl2StalkerScream.play()
	update_values()
