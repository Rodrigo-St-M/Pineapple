extends Node

enum Busses {
	MUSIC,
	SFX
}

var busArray : Array[String]

func _ready() -> void:
	busArray.push_back(AudioServer.get_bus_name(0))
	busArray.push_back(AudioServer.get_bus_name(1))
	busArray.push_back(AudioServer.get_bus_name(2))

## Plays the given audio stream
## returns the audio's name, in case caller wants to stop the audio mid playing
func play_sound(stream :AudioStream, bus :Busses) -> StringName:
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.bus = busArray[bus + 1]
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()
	return instance.name

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()

func stop_sound(audio_name: StringName):
	#print(audio_name)
	var instance : AudioStreamPlayer = find_child(audio_name, true, false)
	#print(instance)
	if instance:
		instance.stop()
		instance.queue_free()
