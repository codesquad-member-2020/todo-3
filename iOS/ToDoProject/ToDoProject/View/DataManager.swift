//
//  DataManager.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class DataManager {
    
    static let ToDoCardsDecodedNotification = NSNotification.Name("ToDoCardsDecodedNotification")
    static var cardsData: ToDoCardInfo?
    static var cardCount: String?
    static func cardsDataCount() -> Int?{
        DataManager.cardsData?.responseData.cards.count ?? 0
    }
    
    static func requestData(of column: String) {
        let toDoCardsURL =
        "http://15.164.78.121:8080/api/columns/\(column)"
        guard let url = URL(string: toDoCardsURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(ToDoCardInfo.self, from: data)
                self.cardsData = decodedData
                self.cardCount = " \( decodedData.responseData.cards.count)"
                self.sendNotification()
            } catch {
                self.cardsData = nil
            }
        }.resume()
    }
    
        static func requestAddCard(card: AddCardForm) {
        let encoder = JSONEncoder()

        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let jsonData = try? encoder.encode(card)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            
            let url = URL(string: "http://15.164.78.121:8080/api/cards")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
                   guard let data = data, error == nil else {
                       print("error=\(error)")
                       return
                   }
                    
                   if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                       print("statusCode should be 200, but is \(httpStatus.statusCode)")
                       print("response = \(response)")
                   } else {
                    print("statusCode is 200, Success")
                }
                    
                   let responseString = String(data: data, encoding: .utf8)
                   print("responseString = \(responseString)")
            }
            task.resume()
        }
    }

    private static func sendNotification() {
        NotificationCenter.default.post(name: DataManager.ToDoCardsDecodedNotification, object: nil,userInfo: ["cardCount": cardCount!])
    }
}
