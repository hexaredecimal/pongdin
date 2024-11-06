package game

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"
Menu :: struct {
	items: [3]string,
	index: i32,
	game:  ^Game,
}

new_menu :: proc(game: ^Game) -> Menu {
	items := [3]string{"Play", "Credits", "Exit"}
	return Menu{items, 0, game}
}

handle_menu :: proc(using menu: ^Menu, sounds: GameSounds) {
	if rl.IsKeyPressed(.UP) {
		index -= 1
		rl.PlaySound(sounds.cock)
	} else if rl.IsKeyPressed(.DOWN) {
		index += 1
		rl.PlaySound(sounds.cock)
	} else if rl.IsKeyPressed(.ENTER) {
		rl.PlaySound(sounds.start)
		switch items[index] {
		case "Play":
			game.play = true
			game.show_menu = false
			rl.PlaySound(sounds.lockandload)
		}
	}
	if index < 0 do index = 0
	if index >= len(items) do index = len(items) - 1
}


draw_menu :: proc(using menu: Menu) {
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	x := width / 2 - 100
	y := height / 2 - 100
	y_pad :: 30
	for i := i32(0); i < len(items); i += 1 {
		buffer := strings.Builder{}
		color := rl.ORANGE
		selected := index % len(items)
		if i == selected {
			fmt.sbprintf(&buffer, "[%s]", items[i])
			color = rl.BLUE
		} else do fmt.sbprintf(&buffer, "%s", items[i])
		text := strings.clone_to_cstring(strings.to_string(buffer))
		rl.DrawText(text, x, y, 30, color)
		y += y_pad
	}
}
