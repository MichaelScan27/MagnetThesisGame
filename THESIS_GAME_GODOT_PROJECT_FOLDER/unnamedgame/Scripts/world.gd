# SCRIPT FOR ROOT NODE OF EACH LEVEL

extends Node3D

@onready var crosshair = $UI/Crosshair

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.max_fps = 60 # lock framerate
	crosshair.position.x = get_viewport().size.x / 2 - 36 # position crosshair
	crosshair.position.y = get_viewport().size.y / 2 - 36
	print("Loaded ", self.name)
	
# Handles quitting and restarting so that these functions are global, regardless of if the player failed to load.
func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
