//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by DEEP BHUPATKAR on 22/04/24.
//

import SwiftUI

@main
struct AppEntry: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty{
                YourNameView()
                
            }else{
                StartView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
