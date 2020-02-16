/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.swift                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:53:04 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:53:12 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation
import Darwin

let options = parseOptions()
let gridSize = Int(options.first(where: { $0.short == "s" })?.value ?? "3")!
let heuristic = AvailableHeuristicMethods[options.first(where: { $0.short == "h" })?.value ?? "linear"]!
let isVerboseModeActivated = (options.first(where: { $0.short == "v" })?.value ?? "false") == "true"
let fileName = options.first(where: { $0.short == "f" })?.value ?? nil
let isHelpRequested = (options.first(where: { $0.long == "help" })?.value ?? "false") == "true"

if isHelpRequested {
	printUsage()
	exit(EXIT_SUCCESS)
}

var grid: [[Int]]? = nil
if let fileName = fileName {
	grid = getGridFromFile(fileName: fileName)
	print("Received a \(grid!.count)x\(grid!.count) grid:")
	print(grid: grid!)
} else {
	grid = generateGrid(ofSize: gridSize)
	print("Generating a \(gridSize)x\(gridSize) grid:")
	print(grid: grid!)
}

if let grid = grid {
	if isGridSolvable(grid) == false {
		print("\nThis grid cannot be solved.")
	} else {
		print("\nStart resolution using: \(heuristic.label)\n")
		printResultReport(result: runAStarWith(grid: grid, andHeuristicFunction: heuristic.method, inVerboseMode: isVerboseModeActivated))
	}
}
