# SCRIPT FOR PROJECTILE BEHAVIOR

extends Node3D

const SPEED = 40.0 # Default speed
var velocity = Vector3(0, 0, -SPEED)
var hit: bool = false; # Set to true after a projectile collides; prevents duplicate function calls

@onready var mesh = $MeshInstance3D # Reference to the mesh
@onready var ray = $RayCast3D # Reference to the ray; needed to detect a collision
@onready var particles = $GPUParticles3D # Reference to particle emitter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * velocity * delta # Attempt movement each frame
	if ray.is_colliding(): # Further actions need only performed if a collision was detected
		# Visuals for projectile colliding
		mesh.visible = false
		particles.emitting = true
		
		if ray.get_collider().is_in_group("mag") && !hit: #If projectile collides with a mag_box AND a collision is not currently active
			if (is_in_group("Pos")): # If projectile was 'Pos'
				ray.get_collider().pos()
				hit = true;
			else:
				ray.get_collider().neg() # If projectile was 'Neg'
				hit = true;
			
			await get_tree().create_timer(1.0).timeout
			queue_free()
		elif(ray.get_collider().is_in_group("level_change") && !hit): #If projectile collides with a level_change object
			print("Loading level #", ray.get_collider().level)
			match ray.get_collider().level: # Switch-case for level-changing debug
				0:
					get_tree().change_scene_to_file("res://Scenes/debug.tscn")
				1: 
					get_tree().change_scene_to_file("res://Scenes/world1.tscn")
				2:
					get_tree().change_scene_to_file("res://Scenes/world2.tscn")
				3:
					get_tree().change_scene_to_file("res://Scenes/world3.tscn")
				4:
					get_tree().change_scene_to_file("res://Scenes/world4.tscn")
				5:
					get_tree().change_scene_to_file("res://Scenes/world5.tscn")
					
			
			
func _on_timer_timeout():
	queue_free() # Removes bullet after timer ends
		
