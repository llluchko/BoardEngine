//
//  Player.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

class Player {
	let name: String
	var score: Int = 0
	
	init(name: String) {
		self.name = name
	}
	
	func updateScore(score: Int) {
		self.score += score
	}
}

extension Player: CustomStringConvertible {
	var description: String {
		return "\(name)->\(score)"
	}
}
