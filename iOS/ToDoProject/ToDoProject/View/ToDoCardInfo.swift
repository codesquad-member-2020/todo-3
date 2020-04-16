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

struct NewCardForm: Codable{
    let colName: String
    let row: Int
    let title: String
    let contents: String
    let writer: String
}

struct ResponseDataForm: Codable {
    let responseMessage: String
    let responseData: Card
}

struct DeleteCardForm: Codable {
    let id: Int
}

struct MoveCardForm: Codable {
    let originColName: String
    let originRow: Int
    let destinationColName: String
    let destinationRow: Int
}
