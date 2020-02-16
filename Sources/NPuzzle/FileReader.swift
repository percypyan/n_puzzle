/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   FileReader.swift                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:54:20 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:54:20 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation


func getGridFromFile(fileName: String) -> [[Int]]? {
	var grid: [[Int]] = []
	var gridSize: Int? = nil
	do {
		let fileContent = try String(contentsOfFile: fileName)
		let lines = fileContent
			.split(separator: "\n")
			.map({ (" \($0)".split(separator: "#").first ?? "").trimmingCharacters(in: [" "]) })

		for line in lines {
			if let size = gridSize {
				let gridRow: [Int?] = line.split(separator: " ").map({ Int($0) })
				if gridRow.count != size || gridRow.contains(nil) {
					break
				}
				grid.append(gridRow as! [Int])
			} else if gridSize == nil && line.count > 0 {
				if let size = Int(line) {
					gridSize = size
				} else {
					break

				}
			}
		}
	} catch {
		terminate(withError: NPuzzleError(kind: .fileNotFound, message: "File \(fileName) not found."))
	}

	if gridSize == nil || grid.count != gridSize! {
		terminate(withError: NPuzzleError(kind: .invalidFile, message: "Unable to parse a grid from file \(fileName)."))
	}

	return grid
}
