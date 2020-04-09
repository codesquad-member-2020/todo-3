//
//  DataManager.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class DataManager {
    private let microDustURL = "https://49f69bb9-2cf6-4590-af83-a8890ac67d7c.mock.pstmn.io/requestCardList"
    
    private(set) var totalToDoCards: ToDoCardInfo?
    
    init() {
        decodeJson()
    }
    
    func totalToDoCardsCount() -> Int?{
        return totalToDoCards?.responseMessage.count
    }
    
    private func decodeJson(){
        guard let url = URL(string: microDustURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { self.totalToDoCards = nil; return }
            guard let data = data else { self.totalToDoCards = nil; return }
            let decoder = JSONDecoder()
            do{
                self.totalToDoCards = try decoder.decode(ToDoCardInfo.self, from: data)
                print(self.totalToDoCards)
            } catch {
                self.totalToDoCards = nil
            }
        }.resume()
    }
}
