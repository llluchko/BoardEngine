//
//  Element.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

class Element {
	let letter: Character
	let score: Int
	
	init(letter: Character, score: Int) {
		self.letter = letter
		self.score = score
	}
}

extension Element: CustomStringConvertible {
	var description: String {
		return "\(letter)->\(score)"
	}
}
