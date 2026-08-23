extends Control

const DEFAULT_VOLUME_VALUE : float = -6.0
const DEFAULT_VOLUME_RANGE : float = 12.0

@onready var master_bar: HSlider = $MarginContainer/HBoxContainer/Master/MasterBar
@onready var music_bar: HSlider = $MarginContainer/HBoxContainer/Music/MusicBar
@onready var sfx_bar: HSlider = $MarginContainer/HBoxContainer/SFX/SFXBar

@onready var master_bus := AudioServer.get_bus_index("Master")
@onready var music_bus := AudioServer.get_bus_index("Music")
@onready var sfx_bus := AudioServer.get_bus_index("SFX")

@onready var master_label: Label = $MarginContainer/HBoxContainer/Master/MasterLabel
@onready var music_label: Label = $MarginContainer/HBoxContainer/Music/MusicLabel
@onready var sfx_label: Label = $MarginContainer/HBoxContainer/SFX/SFXLabel

@export var music_stream : AudioStream
@export var sfx_stream : AudioStreamRandomizer
var music_playing : bool

func _ready() -> void:
	TransitionPlayer.play("drop_out_transition")
	music_playing = false


func _on_master_bar_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = master_bar.value 
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(value/100.0))
		master_label.text = str("MASTER - ", round(AudioServer.get_bus_volume_linear(master_bus) * 100), "%")

func _on_music_bar_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = music_bar.value 
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(value/100.0))
		music_label.text = str("MUSIC - ", round(AudioServer.get_bus_volume_linear(music_bus) * 100), "%")
	if !music_playing:
		music_playing = true
		var id = AudioManager.play_sound(music_stream, AudioManager.Busses.MUSIC)
		await get_tree().create_timer(7).timeout
		AudioManager.stop_sound(id)
		music_playing = false


func _on_sfx_bar_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = sfx_bar.value  
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value/100.0))
		sfx_label.text = str("SFX - ", round(AudioServer.get_bus_volume_linear(sfx_bus) * 100), "%")
		var id = AudioManager.play_sound(sfx_stream, AudioManager.Busses.SFX)
		await get_tree().create_timer(2).timeout
		AudioManager.stop_sound(id)
