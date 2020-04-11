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
    let responseData: [ToDoCard]
}

struct ToDoCard: Codable {
    let colName: String
    let cardList: [Card]
}

struct Card: Codable {
    let id: Int
    let row: Int
    let title: String
    let contents: String
    let writer: String
    let deleted: Bool
    let writtenTime: String
}
