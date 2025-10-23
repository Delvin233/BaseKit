extends Node

var  scores = 0
@onready var end: Label = $end

func add_points():
	scores += 1
	end.text = " Complete : 
		You collected " + str(scores) + " coins." 
