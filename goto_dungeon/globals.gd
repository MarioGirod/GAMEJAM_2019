extends Node

var current_scene = null
var win_scene = null
var thread_pool = []

func _ready():
	#On load set the current scene to the last scene available
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)	


func switch_scene(scene_path):
	var old_scene = current_scene
	# removes nodes from tree but they still ned to be deleted
	get_tree().get_root().remove_child(old_scene)
	current_scene = load(scene_path).instance()
	get_tree().get_root().add_child(current_scene)

	var new_thread = Thread.new()
	new_thread.start(self, "delete_scene", old_scene)
	thread_pool.append(new_thread)
	

func delete_scene(old_scene):
	yield(get_tree().create_timer(1.0), "timeout")
	# the sleep pervents the scene deletion to freze the programm on scene chenge
	old_scene.queue_free()

func _exit_tree():
	for thread in thread_pool:
    	thread.wait_to_finish()