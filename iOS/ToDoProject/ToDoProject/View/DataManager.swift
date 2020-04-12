//
//  DataManager.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class DataManager {
    
    private static let toDoCardsURL = "http://15.164.78.121:8080/api/cards/show"
    static let ToDoCardsDecodedNotification = NSNotification.Name("ToDoCardsDecodedNotification")
    static var totalToDoCards: ToDoCardInfo?
    
    static func totalToDoCardsCount() -> Int?{
        return totalToDoCards?.responseData[0].cardList.count ?? 0
    }
    
    static func requestData(){
        guard let url = URL(string: DataManager.toDoCardsURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do{
                self.totalToDoCards = try decoder.decode(ToDoCardInfo.self, from: data)
                self.sendNotification()
            } catch {
                self.totalToDoCards = nil
            }
        }.resume()
    }
    
    private static func sendNotification() {
        NotificationCenter.default.post(name: DataManager.ToDoCardsDecodedNotification, object: nil)
    }
}
