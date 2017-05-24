//
//  Bonus.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

class Position {
	var type: String?
	var multiplier: Int?
	var element: Element?
	
	init() {
		type = nil
		multiplier = nil
		element = nil
	}
	
	init(type: String, multiplier: Int) {
		self.type = type
		self.multiplier = multiplier
	}
	
	func hasBonus() -> Bool {
		return type != ""
	}
	
	func setElement(element: Element) {
		self.element = element
	}
	
	func hasElement() -> Bool {
		return element != nil
	}
}

extension Position: CustomStringConvertible {
	var description: String {
		return "\(String(describing: type))-\(String(describing: multiplier))-\(String(describing: element))"
	}
}
