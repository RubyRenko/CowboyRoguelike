extends Node2D
@onready var already_bought = get_tree().get_root().get_node("Main").get_node("CowboyPlayer").inventory
@onready var item_list = {
	"jackalope" : load("res://Items/jackalop_pickup.tscn"),
	"double_chamber" : load("res://Items/double_chamber.tscn"),
	"wampus" : load("res://Items/wampus_pickup.tscn"),
	"flatwoods" : load("res://Items/flatwoods_pickup.tscn"),
	"gator" : load("res://Items/gator_pickup.tscn"),
	"darkhat" : load("res://Items/dark_watcher_pickup.tscn"),
	"chili" : load("res://Items/chili_pickup.tscn"),
	"nessie" : load("res://Items/nessie_pickup.tscn"),
	"sinkhole" : load("res://Items/sinkhole_pickup.tscn"),
	"cadejo" : load("res://Items/cadejo_pickup.tscn"),
	"thunderbird" : load("res://Items/thunderbird_pickup.tscn"),
	"tractor" : load("res://Items/tractor_pickup.tscn")
}

static var pos_items = ["jackalope", "chili", #hp/flat stat increases
						"darkhat", "cadejo", "thunderbird", "tractor", #stackable items
						"double_chamber", "nessie", "sinkhole"] #nonstackable items
# Called when the node enters the scene tree for the first time.
func _ready():
	if "double_chamber" in already_bought:
		pos_items.pop_at(pos_items.find("double_chamber"))
	if already_bought["darkhat"] == 10:
		pos_items.pop_at(pos_items.find("darkhat"))
	var item1 = pos_items.pick_random()
	var item1_instance = item_list[item1].instantiate()
	item1_instance.position = $ItemPoint1.position
	if item1_instance.is_in_group("nonstackable"):
		print("removing ", item1)
		pos_items.pop_at(pos_items.find(item1))
	add_child(item1_instance)
	
	var item2 = pos_items.pick_random()
	var item2_instance = item_list[item2].instantiate()
	item2_instance.position = $ItemPoint2.position
	if item2_instance.is_in_group("nonstackable"):
		print("removing ", item2)
		pos_items.pop_at(pos_items.find(item2))
	add_child(item2_instance)
	
	var item3 = pos_items.pick_random()
	var item3_instance = item_list[item3].instantiate()
	item3_instance.position = $ItemPoint3.position
	if item3_instance.is_in_group("nonstackable"):
		print("removing ", item3)
		pos_items.pop_at(pos_items.find(item3))
	add_child(item3_instance)
	print(pos_items)
	if randi_range(0,1) == 0:
		$YetiShopkeep.queue_free()
	else:
		$BigfootShopkeep.queue_free()
