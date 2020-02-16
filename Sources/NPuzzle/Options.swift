/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Options.swift                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:53:21 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:53:26 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

struct CommandLineOption {
	let short: String?
	let long: String
	let isBoolean: Bool
	let isValid: ((String) -> Bool)?
	var value: String?

	init(short: String? = nil, long: String, isBoolean: Bool = false, isValid: ((String) -> Bool)? = nil) {
		self.short = short
		self.long = long
		self.isBoolean = isBoolean
		self.isValid = isValid
		self.value = nil
	}
}

let availableOptions: [CommandLineOption] = [
	CommandLineOption(short: "f", long: "file", isValid: { _ in return true }),
	CommandLineOption(short: "s", long: "size", isValid: { Int($0) != nil && Int($0)! >= 3 }),
	CommandLineOption(short: "h", long: "heuristic", isValid: { AvailableHeuristicMethods.keys.contains($0) }),
	CommandLineOption(short: "v", long: "verbose", isBoolean: true),
	CommandLineOption(long: "help", isBoolean: true)
]

func parseOptions() -> [CommandLineOption] {
	var optionList: [CommandLineOption] = []
	var nextOption: CommandLineOption? = nil

	for argument in CommandLine.arguments.dropFirst() {
		/* Get value of option */
		if var option = nextOption {
			var isValid = true
			if let isValidFunction = option.isValid {
				isValid = isValidFunction(argument)
			}
			if isValid {
				option.value = argument
				optionList.append(option)
				nextOption = nil
			} else {
				terminate(withError: NPuzzleError(kind: .invalidCLIOption, message: "Invalid option `\(argument)`."))
			}
			continue
		}
		/* Get next option */
		if argument.starts(with: "--") {
			nextOption = availableOptions.first(where: { $0.long == argument.dropFirst(2) })
			if nextOption == nil {
				terminate(withError: NPuzzleError(kind: .invalidCLIOption, message: "Invalid option `\(argument)`."))
			}
		} else if argument.starts(with: "-") {
			nextOption = availableOptions.first(where: { $0.short ?? "" == argument.dropFirst(1) })
			if nextOption == nil {
				terminate(withError: NPuzzleError(kind: .invalidCLIOption, message: "Invalid option `\(argument)`."))
			}
		} else {
			terminate(withError: NPuzzleError(kind: .invalidCLIOption, message: "Invalid argument `\(argument)`."))
		}
		if var option = nextOption, option.isBoolean {
			option.value = "true"
			optionList.append(option)
			nextOption = nil
		}
	}

	let fileIsSpecified = optionList.first(where: { $0.short == "f" }) != nil
	let sizeIsSpecified = optionList.first(where: { $0.short == "s" }) != nil
	if fileIsSpecified && sizeIsSpecified {
		terminate(withError: NPuzzleError(kind: .invalidCLIOption, message: "Incompatible options `--file` and `--size` has both been specified."))
	}

	return optionList
}
