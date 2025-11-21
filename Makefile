export:
	rm -rf bin/web
	mkdir -p bin/web
	touch bin/.gdignore
	godot --headless --export-debug "Web" bin/web/index.html

publish:
	butler push bin/web nielmclaren/game-template:web

status:
	butler status nielmclaren/game-template:web

release-linux:
	rm -rf bin/linux
	mkdir -p bin/linux
	touch bin/.gdignore
	godot --headless --export-release "Linux" bin/linux/game.x86_64
	butler push bin/linux nielmclaren/game-template:linux

release-windows:
	rm -rf bin/windows
	mkdir -p bin/windows
	touch bin/.gdignore
	godot --headless --export-release "Windows Desktop" bin/windows/game.exe
	butler push bin/windows nielmclaren/game-template:windows

release-osx:
	rm -rf bin/osx
	mkdir -p bin/osx
	touch bin/.gdignore
	godot --headless --export-release "macOS" bin/osx/game.app
	butler push bin/osx nielmclaren/game-template:osx
