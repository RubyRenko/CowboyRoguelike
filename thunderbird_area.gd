extends Area2D

var in_range = []
var damage = 2
var level = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		$CollisionShape2D.scale = Vector2(level * 10, level * 10)
		set_particles(level)

func deal_dmg():
	print("dealing thunder damage")
	for enemy in in_range:
		enemy.hp -= damage

func set_particles(level):
	$CPUParticles2D.emission_sphere_radius = level * 50

func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("enemy"):
		in_range.append(body)
		print(in_range)

func _on_body_exited(body):
	if body in in_range:
		in_range.pop_at(in_range.find(body))
		print(in_range)
