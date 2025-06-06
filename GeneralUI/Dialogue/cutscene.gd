extends Node

@onready var dialogue_label = $Panel/Label
@onready var speaker_name_label = $Panel/SpeakerNameLabel
@onready var background_texture_rect = $Panel/TextureRect
@onready var song = $MusicPlayer


var dialogue_data : Array = [
{ "image": preload("res://Assets/cutscene assets/cutscene 1.png"), "lines": [
		{"speaker": "Player", "text": "You know... these lands are not made for the weak; The moon gives power to the fiercest gangs of beasts I've ever seen."},
		{"speaker": "Cowboy", "text": "But, you were the one that brought those devils to justice, were you not?"},
		{"speaker": "Player", "text": "You're gonna ask me how I did it, huh? That's a whole can of worms you're opening up kid."},
		{"speaker": "Cowboy", "text": "Please, tell me."},
		{"speaker": "Player", "text": "Fine, kid. I'll tell you, but it's a long tale."}
	]},
	{ "image": preload("res://Assets/cutscene assets/cutscene2.png"), "lines": [
		{"speaker": "Player", "text": "From bloodsuckers to bug men, not even the towns are safe from the Blood Moon. Their gangs come in endless waves like damn zombies surrounding me from every side."},
		{"speaker": "Cowboy", "text": "That sounds terrifying. How does one even get out of there without a scratch?"},
		{"speaker": "Player", "text": "Well, it's easy, if you're me. You gotta always be moving around with WASD. However, when they are surrounding you like that, you gotta SHIFT to dash away from your foes. You just gotta get the hang of being mobile like that."},
		{"speaker": "Cowboy", "text": "Tell me more. Didn't you have your famous gun and whip with you?"}
	]},
	{ "image": preload("res://Assets/cutscene assets/cutscene_3.png"), "lines": [
		{"speaker": "Player", "text": "Yup, my good ol' trusty revolver and whip. Great tools for dealing with those vermin."},
		{"speaker": "Cowboy", "text": "You must be a great shot then, huh?"},
		{"speaker": "Player", "text": "You'd be right. All it took was an aim with the CURSOR and a simple flick of the LEFT CLICK to shoot those demons. And when a man is low on rounds, he needs to R to reload."},
		{"speaker": "Cowboy", "text": "What about your whip?"},
		{"speaker": "Player", "text": "Oh yeah, my whip. Sometimes it's hard to get your shot when they're up close to you, so a man needs something that can hit ‘em good up close."},
		{"speaker": "Player", "text": "My whip has never let me down. It gets the job done whenever I RIGHT CLICK. I'd say it even hits them harder than my gun sometimes. There's nothing more satisfying than getting those baddies good."},
		{"speaker": "Cowboy", "text": "You really got some fancy tools on you, don't you? But, what else did you see on your journey?"},
		{"speaker": "Player", "text": "That's a good question. You'd honestly be shocked to hear."}
	]},    
	{ "image": preload("res://Assets/cutscene assets/cutscene4.png"), "lines": [
		{"speaker": "Player", "text": "Despite the constant bloodshed of what seemed like thousands of waves of monsters, I occasionally encountered this strange merchant who would sell me goods. Those goods helped me along the way so thank the lord he was there."},
		{"speaker": "Cowboy", "text": "Quite peculiar, did this shopkeeper have a name?"},
		{"speaker": "Player", "text": "Eh, never really got a name, so I just called him Mr. Biggs. However, I think that man had a twin brother, or a lover, or something."},
		{"speaker": "Cowboy", "text": "Now, you still haven't told me the nitty-gritty of this tale, friend. What did you fight? Who did you slay? Where did you go?"},
		{"speaker": "Player", "text": "Jeez kid, you really are eager, aren't you? Fine then, I guess it would be rude of me to not go into such detail-"},
		{"speaker": "Cowboy", "text": "Oh, and one more question!"},
		{"speaker": "Player", "text": "What?"},
		{"speaker": "Cowboy", "text": "You got a name for this great tale?"},
		{"speaker": "Player", "text": "Hm. (pause) I believe I do."}
	]}
]

var current_image_index : int = 0
var current_line_index : int = 0

func show_next_line():
	if current_line_index < dialogue_data[current_image_index]["lines"].size():
		var current_dialogue = dialogue_data[current_image_index]["lines"][current_line_index]
		speaker_name_label.text = current_dialogue["speaker"]
		dialogue_label.text = current_dialogue["text"]
		current_line_index += 1
		
	else:
		current_image_index += 1
		current_line_index = 0
		if current_image_index < dialogue_data.size():
			background_texture_rect.texture = dialogue_data[current_image_index]["image"]
			show_next_line()
		else:
			get_tree().change_scene_to_file("res://GeneralUI/main_menu2.tscn")

	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		show_next_line()
		
func _ready():
	song.play_song("intro")
	background_texture_rect.texture = dialogue_data[current_image_index]["image"]
	show_next_line()
	
