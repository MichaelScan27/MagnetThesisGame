# SCRIPT FOR BUTTON ACTIVATION DETECTION

extends Area3D

@onready var door0 = $"../MapEnvironment/CSGBox3D4" # Reference to a 1st door on a level
@onready var door1 = $"../MapEnvironment/CSGBox3D6" # Reference to a 2nd door on a level
@export var button = 0; # Instance variable to track what door this button should open

func _ready():
	# Connects signals from Area3D to functions
	body_entered.connect(_on_body_entered) 
	body_exited.connect(_on_body_exited)
	
func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node):
	# Disables doors when a mag_box enters a button Area3D
	if body.is_in_group("mag"):
		print(self.name, " says: Object entered button range: ", body.name)
		match button:
			0:
				door0.visible = false
				door0.collision_layer = 0
				door0.collision_mask = 0
			1:
				door1.visible = false
				door1.collision_layer = 0
				door1.collision_mask = 0
		

func _on_body_exited(body: Node):
	# Enables doors when mag_boxes leave a button Area3D
	if body.is_in_group("mag"):
		print(self.name, " says: Object exited button range: ", body.name)
		match button:
			0:
				door0.visible = true
				door0.collision_layer = 1
				door0.collision_mask = 1
			1:
				door1.visible = true
				door1.collision_layer = 1
				door1.collision_mask = 1
		
		#print(body.position)
