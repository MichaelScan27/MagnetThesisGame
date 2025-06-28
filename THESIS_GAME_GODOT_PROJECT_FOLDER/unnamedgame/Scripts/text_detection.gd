# SCRIPT FOR MANAGING TUTORIAL TEXT

extends Area3D

@onready var tutorial_text = $"../../UI/tutorial text"
@export var text_num = 0

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	pass

# CALLED FROM local_player_detection.gd
# Regions are structured in levels such that multiple displayText() calls can occur before a hideText() one does.
# This allows for variable lengths/structures in sets of text that are sent to the player
func displayText() -> void:
	match text_num:
				0:
					tutorial_text.text = "Push the left control stick up to walk forward."
				1: 
					tutorial_text.text = "Push the left control stick up to walk forward." + "\nPush left and right to strafe."
				2:
					tutorial_text.text = "Push the left control stick up to walk forward." + "\nPush left and right to strafe." + "\nPush down to walk backward." + "\nRotate the right control stick slowly to look around."
				3:
					tutorial_text.text = "Push the left control stick up to walk forward." + "\nPush left and right to strafe." + "\nPush down to walk backward." + "\nRotate the right control stick slowly to look around." + "\nPress A or B to jump."
				4:
					tutorial_text.text = "Use your triggers to shoot.  Aim and fire at the red block to advance to the next level."
				5:
					tutorial_text.text = "The blue cubes ahead of you are magnets." + "\nTheir color represents their polarity: " +"\n - Blue is south." + "\n - Red is north." + "\n - Purple means the magnet has no polarity." + "\n\nThe device you hold can polarize these magnets." + "\nPress the Left Trigger to fire a positive polarity." + "\nPress the Right Trigger to fire a negative polarity." + "\n\nReach the end of the room.  Remember that opposites attract."
				6:
					tutorial_text.text = "Please note that the magnetic cubes are perfectly safe to touch."
				7:
					tutorial_text.text = "The red mark on the ceiling is a button.  Activate it."
				8:
					tutorial_text.text = "Magnets can be re-polarized as much you'd like."
				9:
					tutorial_text.text = "You have completed the demo!  Thank you for playing! \nYou can select any of the four levels by \nshooting at the cubes on your left. \nOtherwise, you can experiment with the magnets here or exit the game.  \nPress ESCAPE to exit."
	tutorial_text.visible = true;
	
func hideText() -> void:
	match text_num:
				3:
					tutorial_text.visible = false;
				4:
					tutorial_text.visible = false;
				5:
					tutorial_text.visible = false;
				6:
					tutorial_text.visible = false;
				7:
					tutorial_text.visible = false;
				8:
					tutorial_text.visible = false;
