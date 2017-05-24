//
//  main.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

enum ConfigError: Error {
	case cannotFindFile
}

do {
	guard let path  = Bundle.main.path(forResource: "config", ofType: "txt") else {
		throw ConfigError.cannotFindFile
	}
	var gameConfig = Parser.parseGameConfiguration(path: path)!

	print("Game config file: \n \(gameConfig) \n")
} catch let error {
	print(error)
}
