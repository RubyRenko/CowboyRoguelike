extends Node2D
@onready var audio = $ShopAudio

const nonstackable : Array[String] = ["double_chamber", "nessie", "sinkhole"]

static var pos_items = ["jackalope", "chili", #hp/flat stat increases
						"darkhat", "cadejo", "thunderbird", "tractor", #stackable items
						"double_chamber", "nessie", "sinkhole"] #nonstackable items

# Called when the node enters the scene tree for the first time.
func wait_for_node(path: String) -> void:
	while get_node_or_null(path) == null:
		await get_tree().process_frame

func _ready():
	var main_node = get_tree().get_root().get_node_or_null("Main")
	await wait_for_node("/root/Main/CowboyPlayer")
	var player = get_node("/root/Main/CowboyPlayer")
	var already_bought = player.inventory
	if "double_chamber" in already_bought and "double_chamber" in pos_items:
		print_debug("Popping: " + pos_items.pop_at(pos_items.find("double_chamber")))
	if already_bought["darkhat"] == 10 and "darkhat" in pos_items:
		print_debug("Popping: " + pos_items.pop_at(pos_items.find("darkhat")))
		
	var item1 = pos_items.pick_random()
	var item1_instance : BuyablePickup = load("res://Items/BuyablePickup.tscn").instantiate();
	item1_instance.create_pickup(item1);
	item1_instance.position = $ItemPoint1.position
	if nonstackable.find(item1) != -1:
		print("removing ", pos_items.pop_at(pos_items.find(item1)))
	add_child(item1_instance)
	
	var item2 = pos_items.pick_random()
	var item2_instance : BuyablePickup = load("res://Items/BuyablePickup.tscn").instantiate();
	item2_instance.create_pickup(item2);
	item2_instance.position = $ItemPoint2.position
	if nonstackable.find(item2) != -1:
		print("removing ", pos_items.pop_at(pos_items.find(item2)))
	add_child(item2_instance)
	
	var item3 = pos_items.pick_random()
	var item3_instance : BuyablePickup = load("res://Items/BuyablePickup.tscn").instantiate();
	item3_instance.create_pickup(item3);
	item3_instance.position = $ItemPoint3.position
	if nonstackable.find(item3) != -1:
		print("removing ", pos_items.pop_at(pos_items.find(item3)))
	add_child(item3_instance)	
	
	print(pos_items)
	if randi_range(0,1) == 0:
		$YetiShopkeep.queue_free()
	else:
		$BigfootShopkeep.queue_free()
