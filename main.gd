extends Node2D

@export var item_scene : PackedScene

@onready var countdown_timer = $CountDown
@onready var countdown_label = $UI/Label
@onready var  score_label = $UI/Score
@onready var gameover = $GameOver
@onready var high_scores_label = $"GameOver/high Scores"
var high_scores : Array = []
var item_timer
var score = 0

func _ready():
	item_timer = Timer.new()
	item_timer.wait_time = 1.0
	item_timer.timeout.connect(_on_Item_Timer_timeout)
	add_child(item_timer)
	item_timer.start()
	countdown_timer.start()
	load_high_scores()
	update_score_display()

func _process(_delta):
	var time_left = countdown_timer.wait_time - countdown_timer.time_left
	countdown_label.text = format_time(time_left)

func _on_Item_Timer_timeout():
	var item = item_scene.instantiate()
	var sprite = item.get_node("Sprite2D")
	item.position = Vector2(randf() * get_viewport_rect().size.x, -sprite.texture.get_size().y)
	add_child(item)


func format_time(seconds):
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func _on_count_down_timeout():
	countdown_label.text = "Time's up!"
	item_timer.stop()
	gameover.visible = true
	display_high_scores()
	add_score()
	
func update_score_display():
	score_label.text = "Score: %d" % score
	
func increase_score(amount):
	score += amount
	update_score_display()
	
func decrease_score(amount):
	if score != 0:
		score -= amount
		update_score_display()


func _on_restart_pressed():
	get_tree().reload_current_scene()
	
	
func load_high_scores():
	if not FileAccess.file_exists("res://high_scores.json"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("res://high_scores.json", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	high_scores = json.get_data()

func display_high_scores():
	var scores_text = "High Scores:\n"
	var num = 0
	for scor in high_scores:
		num += 1
		scores_text += str(scor) + "\n"
		if num == 3 :
			break
	high_scores_label.text = scores_text

func add_score():
	high_scores.append(score)
	high_scores.sort()
	if high_scores.size() > 5:
		high_scores.resize(5)  # Keep only top 5 scores
		save_high_scores()

func _compare_scores(a, b):
	return a > b  # Sort in descending order
	
func save_high_scores():
	var file = FileAccess.open("res://high_scores.json" , FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(high_scores)
		file.store_line(json_string)
		file.close()
