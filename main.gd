extends Node2D
@onready var music := $Music
@onready var loop_timer := $MusicLoopTimer
func _on_one_shot_music_start_timeout():
	music.play()


func _on_music_loop_timer_timeout():
	music.play()


func _on_music_finished():
	loop_timer.start()
