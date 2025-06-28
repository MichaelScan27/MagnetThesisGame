# SCRIPT FOR DETECTING OBJECTS IN FRONT OF PLAYER,
# USED FOR DISPLAYING TUTORIAL TEXT

extends Area3D

@onready var player = $"../.."

func _ready():
	# Signals to connect Area3D to functions
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _physics_process(delta: float) -> void:
	var bodies = self.get_overlapping_bodies(); # Get all bodies overlapping with player detection Area3D
	var text_bodies = [];
	for body in bodies: # Separate text
		if body.is_in_group("text") && body != player:  
			text_bodies.append(body)
			
# Calls displayText() when player enters text region
func _on_area_entered(area: Node):
	if area.is_in_group("text") and area != player:
		area.displayText();
		print(player.name, " says: Object entered text reading range: ", area.name)
	
# Calls hideText() when player exits text region
func _on_area_exited(area: Node):
	if area.is_in_group("text") and area != player:
		area.hideText();
		print(player.name, " says: Object exited text reading range: ", area.name)	
