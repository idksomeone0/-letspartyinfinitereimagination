extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
func dotext(n):
	var slotext = $Button/slot/text
	slotext.text = n

func enableSlot(tf):
	var panel = $Button/slot/Panel
	panel.visible = tf

