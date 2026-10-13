class_name Upgrade extends Button

@export var price := 1
@export var quantity := 10
@export var type := "health"

@export var price_increase := 1

func get_current():
	var upgrades : Upgrades = $/root/Upgrades
	return upgrades[type]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrades_loaded() -> void:
	var current = get_current()
	var label : Label = get_child(0)
	price = current * price_increase
	label.text = str(current) + "->" + str(current + quantity)+" ("+str(price)+")"
	


func _on_pressed() -> void:
	var upgrades : Upgrades = $/root/Upgrades
	upgrades.buy_upgrade(type, quantity, price)
