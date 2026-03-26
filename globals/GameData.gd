extends Node

const SAVE_PATH = "user://highscore.save"

var current_score = 0

func save_highscore(score: int) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(score)
	
func load_highscore() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		file.store_var(0)
		file.close()
		return 0
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	return file.get_var()

var music_player : AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.stream = preload("res://assets/audio/3. Concrete Jungle.wav")
	add_child(music_player)

func start_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()
