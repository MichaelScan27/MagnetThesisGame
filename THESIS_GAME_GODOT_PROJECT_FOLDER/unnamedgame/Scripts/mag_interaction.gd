# SCRIPT FOR DETECTING MAG POLARITY CHANGES
# NODE HOLDS ALL MAG BOXES IN A LEVEL

extends Node

var rigid_bodies;

func _ready():
	rigid_bodies = get_children() # Gets all mag_boxes and connects a signal to watch for polarity changes
	for mag_box in rigid_bodies:
		mag_box.polarity_changed.connect(_on_polarity_changed)

# Notifies mag_boxes to briefly unstuck themselves to allow for movement following a polarity change
# Otherwise, movement can't be updated following a polarity change
func _on_polarity_changed(new_polarity: float, mag_box: RigidBody3D):
	print("Polarity changed for ", mag_box.name, " to: ", new_polarity); 
	print("Range for ", mag_box.name, " is: ", mag_box.get_child(3).get_child(0).shape.radius)
	mag_box.get_child(3).action()
