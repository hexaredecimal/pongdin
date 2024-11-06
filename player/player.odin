package player

import "core:strings"
import rl "vendor:raylib"

Player :: struct {
	pos:    rl.Vector2,
	speed:  f32,
	health: i32,
	width:  i32,
	height: i32,
	dx:     f32,
	color:  rl.Color,
}

new :: proc() -> Player {
	rect_width :: 100
	rect_height :: 10
	return Player{0, 7.5, 5, rect_width, rect_height, 0, rl.BLUE}
}

reset :: proc(player: ^Player) {
	player.health = 5
	player.dx = 0
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	player.pos = rl.Vector2{f32(width / 2), f32(height - 20)}
}

draw_player :: proc(using player: Player) {
	rl.DrawRectangle(i32(pos.x), i32(pos.y), width, height, color)
}

move_player :: proc(using player: ^Player) {
	if rl.IsKeyUp(.LEFT) {
		pos.x = pos.x + speed
		dx = -1
	}
	if rl.IsKeyUp(.RIGHT) {
		pos.x = pos.x - speed
		dx = 1
	}
}

draw_player_health :: proc(using player: Player) {
	x := i32(10)
	y := i32(10)
	padding :: 20
	for i := 0; i < int(health); i += 1 {
		rl.DrawCircle(x, y, 6, rl.BLACK)
		rl.DrawCircle(x, y, 4, rl.RED)
		rl.DrawCircle(x, y, 2, rl.YELLOW)
		x += padding
	}
}

draw_game_over :: proc(font_size: ^i32, text: cstring, x: ^i32, interval: ^i32) {
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	y := height / 2
	rl.DrawText(text, x^, y, font_size^, rl.RED)
	font_size^ += 1
	x^ -= 5
	if font_size^ >= 100 do font_size^ = 100
	if x^ <= 10 do x^ = 10
	if (x^ == 10 && font_size^ == 100) {
		start := i32(20)
		end := i32(60)
		max := i32(100)
		index := interval^ % max
		switch index {
		case start ..= end:
			try := strings.clone_to_cstring("Press [Space] to restart")
			try_x := width / 2 - 60
			rl.DrawText(try, try_x, height - 100, 16, rl.BLUE)
			try = strings.clone_to_cstring("Press [M] to go to menu")
			try_x = width / 2 - 60
			rl.DrawText(try, try_x, height - 70, 16, rl.BLUE)
		}
		interval^ += 1
		if interval^ == 100 do interval^ = 1
	}
}
