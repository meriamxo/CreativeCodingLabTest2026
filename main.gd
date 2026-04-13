extends Node2D

var faces = []
var happy_count = 0
var sad_count = 0

@onready var happy_label = $Label_1
@onready var sad_label = $Label_2

func _ready():
	randomize()
	update_labels()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color.BLACK, true)

	for face in faces:
		draw_face(face)

func draw_face(face):
	var pos = face["pos"]
	var radius = face["radius"]
	var col = face["color"]
	var is_happy = face["happy"]
	var eye_count = face["eye_count"]

	draw_arc(pos, radius, 0, TAU, 64, col, 2.0)

	var spacing = radius / float(eye_count + 1)
	for i in range(eye_count):
		var eye_x = pos.x - radius * 0.6 + spacing * (i + 1)
		var eye_y = pos.y - radius * 0.2
		draw_circle(Vector2(eye_x, eye_y), radius * 0.06, col)

	# mouth
	if is_happy:
		draw_arc(
			Vector2(pos.x, pos.y + radius * 0.15),
			radius * 0.45,
			0.2,
			PI - 0.2,
			32,
			col,
			2.0
		)
	else:
		draw_arc(
			Vector2(pos.x, pos.y + radius * 0.55),
			radius * 0.45,
			PI + 0.2,
			TAU - 0.2,
			32,
			col,
			2.0
		)

func make_face():
	var face = {
		"pos": Vector2(
			randi_range(50, int(get_viewport_rect().size.x) - 50),
			randi_range(50, int(get_viewport_rect().size.y) - 50)
		),
		"radius": randf_range(20.0, 150.0),
		"color": Color(randf(), randf(), randf(), 1.0),
		"happy": randi() % 2 == 0,
		"eye_count": randi_range(2, 6)
	}

	faces.append(face)

	if face["happy"]:
		happy_count += 1
	else:
		sad_count += 1

func update_labels():
	happy_label.text = "Happy: " + str(happy_count)
	sad_label.text = "Sad: " + str(sad_count)

func _on_button_pressed():
	var number_of_faces = randi_range(1, 10)

	for i in range(number_of_faces):
		make_face()

	update_labels()
	queue_redraw()
