extends Area2D

@export var fall_speed : int = 100
@export var min_number : int = 0
@export var max_number : int = 4
@onready var sprite =  $Sprite2D

func _ready():
	self.connect("body_entered" , _on_Area2D_body_entered)
	var number = randf_range(min_number , max_number)
	sprite.frame = number

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport_rect().size.y:
		queue_free()  # Remove item if it falls off screen


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		var main = get_tree().root.get_node("Main")  # Adjust if needed to get the right node
		if(sprite.frame == 3):
			main.decrease_score(1)  
		else:
			main.increase_score(1)  
		queue_free()  # Remove the item
	
