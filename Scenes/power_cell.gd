extends "res://Items/InteractionBase.gd"


func interact():
	Inventory.power_cells += 1
	Inventory.update_power_cells.emit()
	queue_free()
