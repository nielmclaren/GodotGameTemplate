class_name FileSystemUtils
extends Object


static func find(root: String, pattern: RegEx) -> Array[String]:
	var result: Array[String]
	var dir: DirAccess = DirAccess.open(root)
	if dir:
		dir.list_dir_begin()
		var filename: String = dir.get_next()
		while filename != "":
			var path: String = "%s/%s" % [root, filename]
			if dir.current_is_dir():
				result.append_array(find(path, pattern))
			elif pattern.search(path):
				result.append(path)
			filename = dir.get_next()
		dir.list_dir_end()

	return result
