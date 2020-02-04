//
//  File.swift
//  
//
//  Created by Perceval Archimbaud on 02/02/2020.
//

import Foundation

struct CommandLineOption {
	let short: String
	let long: String
	let isBoolean: Bool
	let isValid: (String) -> Bool
	var value: String?

	init(short: String, long: String, isBoolean: Bool = false, isValid: @escaping (String) -> Bool) {
		self.short = short
		self.long = long
		self.isBoolean = isBoolean
		self.isValid = isValid
		self.value = nil
	}
}

let availableOptions: [CommandLineOption] = [
//	CommandLineOption(short: "f", long: "file", isValid: { _ in return true }),
	CommandLineOption(short: "s", long: "size", isValid: { Int($0) != nil && Int($0)! >= 3 }),
	CommandLineOption(short: "h", long: "heuristic", isValid: { AvailableHeuristicMethods.keys.contains($0) }),
	CommandLineOption(short: "v", long: "verbose", isBoolean: true, isValid: { AvailableHeuristicMethods.keys.contains($0) })
]

func parseOptions() -> [CommandLineOption] {
	var optionList: [CommandLineOption] = []
	var nextOption: CommandLineOption? = nil

	for argument in CommandLine.arguments {
		/* Get value of option */
		if var option = nextOption {
			if option.isValid(argument) {
				option.value = argument
				optionList.append(option)
				nextOption = nil
			} else {
				fputs("Invalid value for option `\(argument)`.\n", stderr)
				exit(EXIT_FAILURE)
			}
			continue
		}
		/* Get next option */
		if argument.starts(with: "--") {
			nextOption = availableOptions.first(where: { $0.long == argument.dropFirst(2) })
			if nextOption == nil {
				fputs("Invalid option `\(argument)`.\n", stderr)
				exit(EXIT_FAILURE)
			}
		} else if argument.starts(with: "-") {
			nextOption = availableOptions.first(where: { $0.short == argument.dropFirst(1) })
			if nextOption == nil {
				fputs("Invalid option `\(argument)`.\n", stderr)
				exit(EXIT_FAILURE)
			}
		}
		if var option = nextOption, option.isBoolean {
			option.value = "true"
			optionList.append(option)
			nextOption = nil
		}
	}
	
	return optionList
}
