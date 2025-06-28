# SCRIPT FOR DETECTING MAG_BOX RANGES

extends Area3D

@onready var mag_box = $".."; # Reference to the mag_box responsible
@onready var collision = $"../Collision" # Reference to collision
@onready var collision_detection = $"../CollisionDetection" # Reference to collision Area3D

var is_overlapping = false # Cube can only move if they aren't colliding or intersecting in anyway

func _ready():
	# Connects signals from Area3Ds to functions, for debugging
	body_entered.connect(_on_body_entered_range)
	body_exited.connect(_on_body_exited_range)
	collision_detection.body_entered.connect(_on_body_entered_collision)
	collision_detection.body_exited.connect(_on_body_exited_collision)
	
func _physics_process(delta: float) -> void:
	var bodies = self.get_overlapping_bodies(); # Get all bodies inside the Area3D
	var mag_bodies = [];
	
	# Separate out mag_boxes into special array 
	for body in bodies:
		if body.is_in_group("mag") && body != mag_box:  
			mag_bodies.append(body)
			
	if (mag_bodies): # If at least one mag_box was found
		for body in mag_bodies: # For each one found, assess movement to be made
			if distance(mag_box, body) > 0.0 :  # Boxes are not at the exact same position
				if (mag_box.range > body.range): # If the box running this check is the stronger magnet, then do movement
					var polarity_modifier = mag_box.polarity * body.polarity
					if (polarity_modifier < 0 && !body.detection.is_overlapping): # ATTRACTION
						var movement = polarity_modifier * direction(mag_box, body) * delta * 5
						body.position += movement
					elif (polarity_modifier > 0 && !body.detection.is_overlapping): # REPULSION
						var movement = polarity_modifier * direction(mag_box, body) * delta * 5
						body.position += movement

# FOR DEBUGGING PURPOSES 
func _on_body_entered_range(body: Node):
	if body.is_in_group("mag") and body != mag_box:
		print(mag_box.name, " says: Object entered range: ", body.name)

func _on_body_exited_range(body: Node):
	if body.is_in_group("mag") and body != mag_box:
		print(mag_box.name, " says: Object exited range: ", body.name)

func _on_body_entered_collision(body: Node):
	if body.is_in_group("mag") and body != mag_box and mag_box.mobile != false:
		is_overlapping = true;
		print(mag_box.name, " says: Object entered collision: ", body.name)

func _on_body_exited_collision(body: Node):
	if body.is_in_group("mag") and body != mag_box and mag_box.mobile != false:
		is_overlapping = false;
		print(mag_box.name, " says: Object exited collision: ", body.name)

# Returns the direction between two bodies as a Vector3
func direction(body1: Node, body2: Node) -> Vector3:
	var position1 = body1.global_transform.origin
	var position2 = body2.global_transform.origin 
	var direction = position2 - position1
	direction = direction / direction.length()
	return direction

# Returns the distance between two bodies as a Vector3
func distance(body1: Node, body2: Node) -> float:
	var position1 = body1.global_transform.origin
	var position2 = body2.global_transform.origin 
	var distance = position2 - position1
	return distance.length()

# Method triggered to unstuck cubes and ensure proper movement logic
func action():
	is_overlapping = false
