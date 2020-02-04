//
//  main.swift
//  n_puzzle
//
//  Created by Perceval Archimbaud on 31/01/2020.
//  Copyright © 2020 Archimbaud. All rights reserved.
//

import Foundation
import Darwin

let originalGrid = [ // Misplaced | Manhattan | Manhattan Linear Conflict
//	[7, 5, 1], // 303 states - 0,076s | 53 states - 0,006s | 35 states - 0,006s
//	[2, 4, 3],
//	[8, 6, 0],

	[3, 2, 7], // 13138 states - 89,913s | 1015 states - 0,626s | 694 states - 0,361s
	[4, 6, 1],
	[5, 8, 0],

//	[2, 4, 1], // 2729 states - 4,405s | 333 states - 0,084s | 78 states - 0,015s
//	[7, 6, 8],
//	[3, 5, 0],

//	[5, 7, 2], // 5094 states - 14,428s | 459 states - 0,153s | 287 states - 0,088s
//	[4, 6, 8],
//	[1, 3, 0],

//	[5, 2, 4], // 12463 states - 81,454s | 742 states - 0,353s | 548 states - 0,246s
//	[1, 6, 8],
//	[3, 7, 0],
]

let hardestGrid = [
	[8, 6, 7],
	[2, 5, 4],
	[3, 0, 1]
]

let options = parseOptions()
let gridSize = Int(options.first(where: { $0.short == "s" })?.value ?? "3")!
let heuristic = AvailableHeuristicMethods[options.first(where: { $0.short == "h" })?.value ?? "linear"]!
let isVerboseModeActivated = (options.first(where: { $0.short == "v" })?.value ?? "false") == "true"

let grid = generateGrid(ofSize: gridSize)
print("Generating a \(gridSize)x\(gridSize) grid:")
print(grid: grid)

print("\nStart resolution using: \(heuristic.label)\n")
printResultReport(result: runAStarWith(grid: grid, andHeuristicFunction: heuristic.method, inVerboseMode: isVerboseModeActivated))
