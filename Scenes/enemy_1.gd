extends CharacterBody3D

@onready var stateMachine: Node = $StateMachine

func _ready() -> void:
	stateMachine.init(self)	

func _physics_process(delta: float) -> void:
	stateMachine.process_physics(delta)

func _process(delta: float) -> void:
	stateMachine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.process_input(event)
