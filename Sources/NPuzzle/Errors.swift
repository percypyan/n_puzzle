/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Errors.swift                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:54:12 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:54:13 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

let usage = """
NPuzzle usage:
	n_puzzle [...options]

Options availables:
	--file (-f) <file_name>
		The file to get the grid from.
		Incompatible with the `--size` option.
		The grid is described with lines of numbers preceed with the grid
		size. The `0` represent the empty tile.
		Example: `
			3 # Comments are allowed
			1 2 3
			4 5 6
			7 8 0
		`

	--size (-s) <grid_size>
		The size of the grid to generate.
		Incompatible with the `--file` option.

	--verbose (-v)
		Display the details of the search.

	--heuristic (-h) <misplaced|manhattan|linear>
		The heuristic to use in the A-star algorithm.
			`misplaced`: use the count of misplaced tiles on the board.
			`manhattan`: use the manhattan distance between each tile and is
				correct position on the board.
			`linear`: use the manhattan heuristic reinforced by the dection
				of linear conflicts that increase the number of moves needed
				by 2 for each conflict.

	--help
		Display this manual.
"""

func printUsage() {
	print(usage)
}

struct NPuzzleError: Error {

	enum ErrorKind: Int32 {
		case fileNotFound = 1
		case invalidFile
		case invalidCLIOption
	}

    var kind: ErrorKind
	var message: String

	var exitCode: Int32 {
		get { kind.rawValue }
	}

	func log() {
		fputs("Error \(exitCode): \(message)\n", stderr)
	}

}

func terminate(withError error: NPuzzleError) {
	error.log()
	exit(error.exitCode)
}
