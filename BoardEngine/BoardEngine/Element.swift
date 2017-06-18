//
//  Element.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

class Element<T: Equatable> {
	let substance: T
	let score: Int

	init(substance: T, score: Int) {
		self.substance = substance
		self.score = score
	}
}

extension Element: CustomStringConvertible {
	var description: String {
		return "\(substance)->\(score)"
	}
}
