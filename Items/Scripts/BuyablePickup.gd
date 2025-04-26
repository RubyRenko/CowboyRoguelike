class_name BuyablePickup
extends Area2D

@export var texture_sprite : Sprite2D
@export var title_label : Label
@export var description_label : Label

var Item_Details : Dictionary = {
								"chili" : {
									"price" : 10,
									"title" : "Chilli\n Bowl",
									"description" : "Fully heals HP\n10$",
									"texture_path": "res://Assets/ItemSprites/bowl of chili-02.png",
									"function" : func(player): player.hp = player.max_hp,
									"scale" : Vector2(0.018, 0.018)
								},
								"jackalope" : {
									"price" : 20,
									"title" : "Roasted Jackalope",
									"description" : "Increases health\n20$",
									"texture_path": "res://Assets/ItemSprites/jackalope.png",
									"function" : func(player):
										player.max_hp += 2
										player.hp += 2,
									"scale" : Vector2(0.6, 0.6)
								},
								"double_chamber" : {
									"price" : 25,
									"title" : "Double Chamber",
									"description" : "Doubles max ammo\n25$",
									"texture_path": "res://Assets/hud assets/bullet chambers-08.png",
									"function" : func(player):
											player.max_ammo += 6
											player.ammo += 6
											player.inventory["double_chamber"] = 1,
									"scale" : Vector2(0.015, 0.015)
								},
								"wampus" : {
									"price" : 10,
									"title" : "Wampus\nPaw",
									"description" : "Increase melee dmg\n10$",
									"texture_path": "res://Assets/ItemSprites/wampus_paw.png",
									"function" : func(player):
										player.melee_dmg += 1
										if "wampus" in player.inventory:
											player.inventory["wampus"] += 1
										else:
											player.inventory["wampus"] = 1,
									"scale" : Vector2(0.7, 0.7)
								},
								"flatwoods" : {
									"price" : 10,
									"title" : "Flatwoods Eye",
									"description" : "Increases ranged dmg\n10$",
									"texture_path": "res://Assets/ItemSprites/flatwood eye-02.png",
									"function" : func(player):
										player.ranged_dmg += 1
										if "flatwoods" in player.inventory:
											player.inventory["flatwoods"] += 1
										else:
											player.inventory["flatwoods"] = 1,
									"scale" : Vector2(0.015, 0.015)
								},
								"gator" : {
									"price" : 10,
									"title" : "Gatorman Scale",
									"description" : "Temporary shield\n10$",
									"texture_path": "res://Assets/ItemSprites/gatorman scale.png",
									"function" : func(player):
										player.armor += 2,
									"scale" : Vector2(0.015, 0.015)
								},
								"darkhat" : {
									"price" : 40,
									"title" : "Dark Watcher Hat",
									"description" : "Gives Stun Chance\n40$",
									"texture_path": "res://Assets/ItemSprites/dark watcher hat-02.png",
									"function" : func(player):
										player.inventory["darkhat"] += 1,
									"scale" : Vector2(0.015, 0.015)
								},
								"nessie" : {
									"price" : 30,
									"title" : "Nessie Tooth",
									"description" : "Piercing bullets\n30$",
									"texture_path": "res://Assets/ItemSprites/nessie tooth-02.png",
									"function" : func(player):
										player.inventory["nessie"] = 1,
									"scale" : Vector2(0.02, 0.02)
								},
								"sinkhole" : {
									"price" : 30,
									"title" : "Sinkhole Sam Boots",
									"description" : "Increases speed\n30$",
									"texture_path": "res://Assets/ItemSprites/sinkhole sam boots-02.png",
									"function" : func(player):
										player.speed = 450.0
										player.inventory["sinkhole"] = 1,
									"scale" : Vector2(0.02, 0.02)
								},
								"cadejo" : {
									"price" : 20,
									"title" : "Cadejo Chains",
									"description" : "Slowing Whip\n20$",
									"texture_path": "res://Assets/ItemSprites/cadejo chain-02.png",
									"function" : func(player):
										player.inventory["cadejo"] += 1,
									"scale" : Vector2(0.02, 0.02)
								},
								"thunderbird" : {
									"price" : 40,
									"title" : "Thunderbird Feather",
									"description" : "Thunder radius\n40$",
									"texture_path": "res://Assets/ItemSprites/thunderbird.png",
									"function" : func(player):
										if "thunderbird" in player.inventory:
											player.inventory["thunderbird"] += 1
											player.thunder.level += 1
										else:
											player.inventory["thunderbird"] = 1
											player.thunder.show()
											player.thunder.level = 1
											player.thunder_timer.start(),
									"scale" : Vector2(0.6, 0.6)
								},
								"tractor" : {
									"price" : 20,
									"title" : "Tractor Beam",
									"description" : "Slowing bullets\n20$",
									"texture_path": "res://Assets/ItemSprites/tractor beam-02.png",
									"function" : func(player):
										player.inventory["tractor"] += 1,
									"scale" : Vector2(0.015, 0.015)
								},
							 }

var sold: bool    = false
var near: bool    = false
var can_buy: bool = false
var price: int
var item_key : String

@onready var player = get_tree().get_root().get_node("Main").get_node("CowboyPlayer")
@onready var shop = get_parent()

func create_pickup(key : String):
	item_key = key
	price = Item_Details[key]["price"]
	texture_sprite.texture = load(Item_Details[key]["texture_path"])
	texture_sprite.scale = Item_Details[key]["scale"]
	title_label.text = Item_Details[key]["title"]
	description_label.text = Item_Details[key]["description"]

func _ready():
	hide_desc()
	if sold:
		$DespawnTimer.start()

func show_desc():
	$TextBox.visible = true
	$Title.visible = true
	$Description.visible = true

func hide_desc():
	$TextBox.visible = false
	$Title.visible = false
	$Description.visible = false

func _on_despawn_timer_timeout():
	queue_free()

func _process(_delta):
	if near and can_buy and Input.is_action_just_pressed("interact"):
		sold = true
		shop.audio.play_sfx("buy")
		player.money -= price
		add_inv()
		queue_free()
	elif near and Input.is_action_just_pressed("interact"):
		shop.audio.play_sfx("no_funds")

func _on_body_entered(body):
	if body.name == "CowboyPlayer" and sold:
		add_inv()
		queue_free()

func _on_selling_interface_body_entered(body):
	if body.name == "CowboyPlayer" and not(sold):
		near = true
		show_desc()
		if body.money >= price:
			can_buy = true
		else:
			can_buy = false

func _on_selling_interface_body_exited(body):
	near = false
	can_buy = false
	hide_desc()

func add_inv():
	var function : Callable = Item_Details[item_key]["function"]
	function.call(player)
