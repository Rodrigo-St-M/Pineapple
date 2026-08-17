extends Control


var gm : GameMaster
var locked_powerups : Array[PlayerState.Attacks] = [
		PlayerState.Attacks.CLAP,
		PlayerState.Attacks.DASH,
		PlayerState.Attacks.PARRY,
		PlayerState.Attacks.PUNCH ]

var current_attacks : Array[PlayerState.Attacks]
var current_options : Array[VBoxContainer]
@onready var option_0: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Option0
@onready var option_1: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Option1
@onready var option_2: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Option2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gm = GameMaster.get_current_instance()
	current_options.append(option_0)
	current_options.append(option_1)
	current_options.append(option_2)

func get_powerup_options() -> Array[PlayerState.Attacks]:
	var options : Array[PlayerState.Attacks]
	for powerup in locked_powerups:
		options.append(powerup)
	options.shuffle()
	options.resize(3)
	return options

func set_powerup_options() -> void:
	current_attacks = get_powerup_options()
	
	for i in 3:
		var opt_button: TextureButton = current_options[i].get_child(0)
		var opt_name: Label = current_options[i].get_child(1)
		var opt_desc: Label = current_options[i].get_child(2)
		
		match current_attacks[i]:
			PlayerState.Attacks.DASH:
				load_berry_option(opt_button, opt_name, opt_desc)
			PlayerState.Attacks.CLAP:
				load_lemon_option(opt_button, opt_name, opt_desc)
			PlayerState.Attacks.PUNCH:
				load_pear_option(opt_button, opt_name, opt_desc)
			PlayerState.Attacks.PARRY:
				load_pom_option(opt_button, opt_name, opt_desc)
	

func load_pear_option( opt_button :TextureButton, opt_name :Label, opt_desc :Label) -> void:
	opt_button.texture_normal = load("uid://blucas5j0u1p6")
	opt_name.text = "uppearcut combo"
	opt_desc.text = "the old one two!\ndo a flying punch on ground,\nfollowed up with a dive bomb!"

func load_pom_option( opt_button :TextureButton, opt_name :Label, opt_desc :Label) -> void:
	opt_button.texture_normal = load("uid://blkovwojbqv68")
	opt_name.text = "power pom parry"
	opt_desc.text = "explosive counter!\nexplode if you get hit!\nslow down on a miss..."

func load_berry_option( opt_button :TextureButton, opt_name :Label, opt_desc :Label) -> void:
	opt_button.texture_normal = load("uid://c2mvk3sdujwqo")
	opt_name.text = "wing berry dash"
	opt_desc.text = "instant momentum!\nless time speeding up,\nmore time punching!"

func load_lemon_option( opt_button :TextureButton, opt_name :Label, opt_desc :Label) -> void:
	opt_button.texture_normal = load("uid://bgmi4hvsyl84n")
	opt_name.text = "citron shockwave"
	opt_desc.text = "sprinkle lemon in.\nyour enemies' eyes!\nknocks you back!"

func select_powerup(selected : PlayerState.Attacks) -> bool:
	if locked_powerups.has(selected):
		locked_powerups.erase(selected)
		gm.get_player().set_new_attack(selected)
		return true
	return false

func _on_opt_0_pressed() -> void:
	select_powerup(current_attacks[0])
	gm.start_level()

func _on_opt_1_pressed() -> void:
	select_powerup(current_attacks[1])
	gm.start_level()

func _on_opt_2_pressed() -> void:
	select_powerup(current_attacks[2])
	gm.start_level()
