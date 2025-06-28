# MAIN SCRIPT FOR MAG_BOX OBJECTS

@tool # Allows script to run in-engine
extends RigidBody3D

@onready var model = $Model # Reference to mesh
@onready var collision = $Collision # Reference to collision
@onready var collision_detection = $CollisionDetection # Reference to collision Area
@onready var detection = $Detection # Reference to range Area
@onready var det_range = $Detection/Range # Reference to Area shape
@onready var det_model = $Detection/RangeModel # Reference to Area model -- for debugging

@export var polarity: float = 0.0: # Instance variable -- mag_box's current polarity.  Includes setter/getter for @tool use
	get: 
		return polarity;
	set(value):
		polarity = value;
	
@export var mobile: bool = true; # If true, box can move
@export var range: float = 0.5: # Defines range that box is magnetic for
	get:
		return range;
	set(value):
		range = value;
		update_range()
@export var mag_sens: float = 0.2; # Defines the scale at which polarity can change

# Separating out the size to an instance variable was needed as the collision and mesh must be changed at the same time.
# This automates that change.
@export var size: Vector3 = Vector3(1, 1, 1): # Defines the size of the object.  Includes setter/getter for @ tool use.
	get:
		return size;
	set(value):
		size = value
		update_size()

signal polarity_changed(new_polarity, mag_box); # Releases signal when polarity changes

var pos_color = Color(3, 0, 0); # Stock color for most positive polarity
var neg_color = Color(0, 0, 3); # Stock color for most negative polarity

var bodies;
var mag_bodies = [];

# Inside the _ready() function
func _ready() -> void:
	# If in editor, run this and nothing else.
	if Engine.is_editor_hint():
		update_size()
		update_range()
		return
		
	# Set all functional properties on init
	mass = range
	det_range.shape.radius = range
	update_range()
	update_polarity()
	update_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	pass
	
# Called to update mesh and collision at once
func update_size(): 
	if is_inside_tree():
		if model and model.mesh is BoxMesh:
			model.scale = size;
			
	if collision and collision.shape is BoxShape3D:
		collision.scale = size;
		
# Called to update range
func update_range():
	if det_model and det_model.mesh is SphereMesh:
		det_model.scale = Vector3(range, range, range)

# Called to update polarity
func update_polarity():
	if Engine.is_editor_hint():
		if model.material_override == null:
			model.material_override = StandardMaterial3D.new()
		model.material_override.albedo_color = neg_color.lerp(pos_color, (polarity + 1)/2) # Interpolates a color based on polarity
		return
	
	emit_signal("polarity_changed", polarity, self);
	if model.material_override == null:
		model.material_override = StandardMaterial3D.new()
	model.material_override.albedo_color = neg_color.lerp(pos_color, (polarity + 1)/2)  # Interpolates a color based on polarity
	#detection.action();
	
	bodies = detection.get_overlapping_bodies();
	if (bodies):
		for body in bodies:
			if body.is_in_group("mag") && body != self:  # Separate out mag_boxes
				mag_bodies.append(body)
			
	# Hit when polarity is changed able to interact with other mag_boxes
	if (mag_bodies):
		for body in mag_bodies:
			print(self.name, " says: I am inside of: ", body.name)
			body.detection.action() # Unstucks box to resume movement
	
# Handles positive polarity change
func pos() -> void:
	if Engine.is_editor_hint():
		return
		
	polarity += mag_sens
	polarity = clamp(polarity, -1.0, 1.0);
	update_polarity();
	
# Handles negative polarity change
func neg() -> void:
	if Engine.is_editor_hint():
		return
		
	polarity -= mag_sens
	polarity = clamp(polarity, -1.0, 1.0);
	update_polarity();
