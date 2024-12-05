package puzzle2

import "core:os"
import "core:fmt"
import "core:strings"

main :: proc(){
	filepath := "./input.txt"
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Error Reading File!")
		return
	}
	defer delete(data, context.allocator)
	
	data_string := string(data)
	column_count := strings.index_rune(data_string, '\n')
	row_count := strings.count(data_string, "\n")
	row_count += 1
	
	table := make([dynamic][dynamic]rune, row_count)
	
	row_index := 0
	for input_char in data_string{
		if input_char == '\n'{
			row_index += 1
			continue
		}
		append(&table[row_index], input_char)
	}
	
	/*
	for rw in 0..<row_count{
		fmt.println(table[rw][:])
	}
	*/
	
	x_mas_count := 0
	opps := [2]int {-1, -1}
	
	dir_vectors := Direction_Vectors
	next_vectors := Next_Vectors
	
	for x in 1..<column_count-1{
		for y in 1..<row_count-1{
			if table[y][x] == 'A'{
				start_pos := [2]int{x, y}
				for direction in Direction{
					dir := dir_vectors[direction]
					x_mas_valid := false
					test_pos := start_pos + dir
					
					if table[test_pos[1]][test_pos[0]] == 'M'{
						test_pos = start_pos + (dir * opps)
						if table[test_pos[1]][test_pos[0]] == 'S'{
							next_vector := next_vectors[direction]
							test_pos = start_pos + next_vector
							if table[test_pos[1]][test_pos[0]] == 'M'{
								test_pos = start_pos + (next_vector * opps)
								if table[test_pos[1]][test_pos[0]] == 'S'{
									x_mas_count += 1
									x_mas_valid = true
								}
							}
							else if table[test_pos[1]][test_pos[0]] == 'S'{
								test_pos = start_pos + (next_vector * opps)
								if table[test_pos[1]][test_pos[0]] == 'M'{
									x_mas_count += 1
									x_mas_valid = true
								}
							}
						}
					}
					
					if x_mas_valid{
						break
					}
				}
			}
		}
	}
	
	fmt.println(x_mas_count)
}

Is_On_Table :: proc(pos : [2]int, table : ^[dynamic][dynamic]rune) -> bool{
	if pos[0] < 0 || pos[0] >= len(table[0]){
		return false
	}
	if pos[1] < 0 || pos[1] >= len(table){
		return false
	}
	return true
}

Direction :: enum{up_right, down_right, down_left, up_left}

Direction_Vectors :: [Direction][2]int{
	.up_right = { 1, -1 },
	.down_right = { 1, 1 },
	.down_left = { -1, 1 },
	.up_left = { -1, -1 }
}

Next_Vectors :: [Direction][2]int{
	.up_right = { 1, 1 },
	.down_right = { -1, 1 },
	.down_left = { -1, -1 },
	.up_left = { 1, -1 }
}