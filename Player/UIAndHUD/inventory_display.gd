extends GridContainer

#item sprites
var item_sprites = {
	"cadejo" : load("res://Assets/ItemSprites/cadejo chain-02.png"),
	"darkhat" : preload("res://Assets/ItemSprites/dark watcher hat-02.png"),
	"double_chamber" : preload("res://Assets/hud assets/bullet chambers-08.png"),
	"flatwoods" : preload("res://Assets/ItemSprites/flatwood eye-02.png"),
	"gator" : preload("res://Assets/ItemSprites/gatorman scale.png"),
	"jackalope" : preload("res://Assets/ItemSprites/jackalope.png"),
	"nessie" : preload("res://Assets/ItemSprites/nessie tooth-02.png"),
	"sinkhole" : preload("res://Assets/ItemSprites/sinkhole sam boots-02.png"),
	"thunderbird" : load("res://Assets/ItemSprites/thunderbird.png"),
	"tractor" : load("res://Assets/ItemSprites/tractor beam-02.png"),
	"wampus" : preload("res://Assets/ItemSprites/wampus_paw.png")
	}
var transparent_txt = preload("res://Assets/hud assets/menus/transparent block.png")

var item_names = {
	"cadejo" : "Cadejo Chains",
	"darkhat" : "Dark Watcher Hat",
	"double_chamber" : "Double Chamber",
	"flatwoods" : "Flatwoods Eye",
	"jackalope" : "Roasted Jackalope",
	"nessie" : "Nessie Tooth",
	"sinkhole" : "Sinkhole Same Boots",
	"thunderbird" : "Thunderbird Feather",
	"tractor" : "Tractor Beam",
	"wampus" : "Wampus\nPaw"
}

var item_desc = {
	"cadejo" : "Slowing whip",
	"darkhat" : "Gives stun chance",
	"double_chamber" : "Doubles max ammo",
	"flatwoods" : "Increases ranged dmg",
	"jackalope" : "Increases health",
	"nessie" : "Piercing bullets",
	"sinkhole" : "Increases speed",
	"thunderbird" : "Damages in thunder radius",
	"tractor" : "Slowing bullets",
	"wampus" : "Increases melee dmg"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_inv(inventory):
	var i = 0
	for item in inventory.keys():
		if inventory[item] != 0:
			get_child(i).texture = item_sprites[item]
			get_child(i).set_item_name(item_names[item])
			get_child(i).set_item_desc(item_desc[item] + "\nx" + str(inventory[item]))
			get_child(i).can_show = true
			i += 1
	
	for j in range(i, get_child_count()):
		#print(j)
		get_child(j).texture = transparent_txt
		get_child(j).can_show = false
