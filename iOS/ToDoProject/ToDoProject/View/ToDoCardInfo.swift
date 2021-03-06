//
//  ToDoCardInfo.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

struct ToDoCardInfo: Codable {
    let responseMessage: String
    var responseData: ToDoCard
}

struct ToDoCard: Codable {
    let id: Int
    let colName: String
    let deleted: Bool
    var cards: [Card]
}

struct Card: Codable {
    let id: Int
    let row: Int
    var title: String
    var contents: String
    let writer: String
    let deleted: Bool
    let writtenTime: String
}

struct AddCardForm: Codable {
    let colName: String
    let title: String
    let contents: String
}

struct NewCardForm: Codable{
    let title: String
    let contents: String
}

struct ResponseDataForm: Codable {
    let responseMessage: String
    let responseData: Card
}

struct MoveCardForm: Codable {
    let destinationId: Int
    let destinationRow: Int
}

struct DraggedCard {
    let draggedCardInfo: Card
    let draggedCardIndex: Int
    let draggedCardColumnId: Int
}

struct CardToDropInfo {
    let sourceColumnId: Int
    let sourceCardRow: Int
    let destinationColumnId: Int
    let destinationCardRow: Int
    let cardToDrop: Card
}
