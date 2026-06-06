extends PlayerState

#var connected_attack : Script = null
#
### Assigns the new attack to this attack button
#func connect_attack(attack : Attacks) -> void:
	#match attack:
		#Attacks.SPIN:
			#connected_attack = load("res://Scripts/player_scripts/attack.gd")
		#Attacks.KICK:
			#pass
		#Attacks.DASH:
			#pass
		#Attacks.PUNCH:
			#pass
	#
#
#func enter() -> void:
	#connected_attack.
