//
//  main.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

var gameConfig: GameConfig!
var gameData: GameData!

enum ConfigError: Error {
	case cannotFindFile
}

do {
	guard let path  = Bundle.main.path(forResource: "config", ofType: "txt") else {
		throw ConfigError.cannotFindFile
	}
	gameConfig = Parser.parseGameConfiguration(path: path)!

	print("Game config file: \n \(gameConfig!) \n")
} catch let error {
	print(error)
}

do {
	guard let path  = Bundle.main.path(forResource: "game", ofType: "txt") else {
		throw ConfigError.cannotFindFile
	}
	
	gameData = Parser.parseGameData(path: path)!
	
	print("Saved game file: \n \(gameData!) \n")
} catch let error {
	print(error)
}

var board = Board(dimensions: (gameConfig?.dimensions)!)

print("Bonuses: \(gameConfig.bonuses)")

for bonus in (gameConfig?.bonuses)! {
	if bonus.type != "WS" && bonus.type != "LS" {
		let currentElement = Element(substance: T(bonus.type), score: bonus.multiplier)
		board[bonus.coordinates.0, bonus.coordinates.1].setElement(element: currentElement)
	}
	else {
		let currentPosition = ScrablePosition(type: bonus.type, multiplier: bonus.multiplier)
		board[bonus.coordinates.0, bonus.coordinates.1] = currentPosition
	}
}

for turn in gameData.turns {
	print(turn)
	let playerWord = Array(turn.word.characters).map { Element(substance: $0, score: Parser.getLetterScore(gameConfig.elements, $0)) }
	
	let playerScore = board.addWord(word: playerWord, startRowCol: turn.startPosition, direction: turn.direction)

	print("Player \(turn.player) scored \(playerScore)")
	print("-------------------------------------------------------------")
}

//print(board)

let game = Bundle.main.path(forResource: "new_game", ofType: "txt")

let emptyText = ""

do {
	try emptyText.write(toFile: game!, atomically: false, encoding: .utf8)
} catch {
	print("Error while deleting content in \(String(describing: game)).")
}

board.saveBoardToFile()
Parser.writeToFile(content: "--LETTERS--", filePath: game!)

for (element, elements) in gameConfig.elements {
	var line = "\(element.substance) \(elements) \(element.score)"
	Parser.writeToFile(content: line, filePath: game!)
}

