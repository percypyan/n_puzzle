/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   GridUtils.swift                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:53:44 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:53:53 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

typealias Grid = [[Int]]

struct GridPosition {
	var x: Int
	var y: Int
}

enum Move: String {
	case up = "U"
	case down = "D"
	case left = "L"
	case right = "R"
}

func isGridSolvable(_ grid: Grid) -> Bool {
	var inversionsCount = 0
	var tilesList: [Int] = []
	for y in 0..<grid.count {
		for x in 0..<grid[y].count {
			if grid[y][x] == 0 { continue }
			tilesList.append(grid[y][x])
		}
	}
	for i in 0...(tilesList.count - 2) {
		for y in i..<tilesList.count {
			if tilesList[i] > tilesList[y] {
				inversionsCount += 1
			}
		}
	}
	if grid.count % 2 == 0 {
		let indexOfLineWithBlank = grid.firstIndex(where: { $0.contains(0) })
		return (inversionsCount + indexOfLineWithBlank!) % 2 == 1
	} else {
		return inversionsCount % 2 == 0
	}
}

func generateGrid(ofSize size: Int) -> Grid {
	var grid: Grid = []
	var valuesList: [Int] = []
	for i in 0...(size * size - 1) {
		valuesList.append(i)
	}
	for y in 0..<size {
		grid.append([])
		for _ in 0..<size {
			let index = Int.random(in: 0..<valuesList.count)
			grid[y].append(valuesList.remove(at: index))
		}
	}
	/* If unsolvable, add or remove a inversion to make it solvable. */
	if isGridSolvable(grid) == false {
		let y = grid[0].contains(0) ? 1 : 0
		grid[y][0] += grid[y][1]
		grid[y][1] = grid[y][0] - grid[y][1]
		grid[y][0] -= grid[y][1]
	}
	return grid
}

func computeGoalGrid(ofSize size: Int) -> Grid {
	// Create a grid filled with 0
	var grid = Grid(repeating: [Int](repeating: 0, count: size), count: size)
	
	var x = 0
	var y = 0
	var xIncrement = 1
	var yIncrement = 0
	
	let tilesCount = size * size
	for tile in 1..<tilesCount {
		grid[y][x] = tile
		
		// Adjust increments if needed
		if xIncrement != 0 && (x + xIncrement == size || x + xIncrement < 0 || grid[y][x + xIncrement] != 0) {
			xIncrement = 0
			yIncrement = y == 0 || grid[y - 1][x] != 0 ? 1 : -1
		} else if yIncrement != 0 && (y + yIncrement == size || y + yIncrement < 0 || grid[y + yIncrement][x] != 0) {
			yIncrement = 0
			xIncrement = x == 0 || grid[y][x - 1] != 0 ? 1 : -1
		}
		
		// Increment coordinates
		x += xIncrement
		y += yIncrement
	}
	
	return grid
}

func print(grid: Grid) {
	let maxValueLenth = "\(grid.count * grid.count - 1)".count
	let formatter = NumberFormatter()
	formatter.formatWidth = maxValueLenth
	let separationLine = String(repeating: "-", count: (maxValueLenth + 3) * grid.count + 1)
	let emptyTile = String(repeating: " ", count: maxValueLenth)
	print(separationLine)
	for y in 0...(grid.count - 1) {
		let line = grid[y].reduce("|") { "\($0) \($1 == 0 ? emptyTile : formatter.string(for: $1)!) |" }
		print(line)
		print(separationLine)
	}
}

func apply(move: Move, toGrid grid: Grid, withZeroPosition zeroPosition: GridPosition) -> Grid {
	var newGrid = grid
	var newZeroPosition = zeroPosition
	switch move {
	case .up:
		newZeroPosition.y -= 1
	case .down:
		newZeroPosition.y += 1
	case .left:
		newZeroPosition.x -= 1
	case .right:
		newZeroPosition.x += 1
	}
	newGrid[zeroPosition.y][zeroPosition.x] = newGrid[newZeroPosition.y][newZeroPosition.x]
	newGrid[newZeroPosition.y][newZeroPosition.x] = 0
	return newGrid
}
