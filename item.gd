extends TextureRect

var can_show = false
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_desc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_show and hovering:
		show_desc()

func show_desc():
	$Textbox.visible = true
	$Title.visible = true
	$Description.visible = true

func hide_desc():
	$Textbox.visible = false
	$Title.visible = false
	$Description.visible = false

func set_item_name(text):
	$Title.text = text

func set_item_desc(text):
	$Description.text = text

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false
	hide_desc()
