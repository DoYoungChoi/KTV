//
//  HomeViewModel.swift
//  KTV
//
//  Created by dodor on 2023/10/31.
//

import Foundation

class HomeViewModel {
    
    private(set) var home: Home?
    var dataChanged: (() -> Void)? // Data 변경에 대한 노티를 받을 수 있는 클로저
    
    func requestData() {
        guard let jsonUrl = Bundle.main.url(forResource: "home", withExtension: "json") else {
            print("home resource not found")
            return
        }
                
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: jsonUrl)
            let home = try jsonDecoder.decode(Home.self, from: data)
            self.home = home
            self.dataChanged?()
        } catch {
            print("json parsing failed: \(error.localizedDescription)")
        }
    }
}
