//
//  GameView.swift
//  TicTacToe
//
//  Created by DEEP BHUPATKAR on 24/04/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game : GameService
    @EnvironmentObject var connectionManger : MPConnectionManager
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy{$0 == false }{
                Text("Select a player to start")
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    
                    .font(.title2).bold()
                    .foregroundStyle(Color.accentColor)
                
            }
            Spacer(minLength: 20)
            HStack{
               
                Button(game.player1.name){
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        
                        let gameMove = MPGameMove (action: .start, playerName: game.player1.name, index: nil)
                        connectionManger.send(gameMove: gameMove)
                    }
                    
                }
                
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                Button(game.player2.name){
                    game.player2.isCurrent = true
                    if game.gameType == .bot{
                        Task{
                            await game.deviceMove()
                        }
                    }
                    if game.gameType == .peer {
                        
                        let gameMove = MPGameMove (action: .start, playerName: game.player2.name, index: nil)
                        connectionManger.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }.position(x:200,y: 50)
            .disabled(game.gameStarted)
            
            VStack{
                
                HStack{
                    ForEach(0...2, id: \.self){ index in
                      SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(3...5, id: \.self){ index in
                      SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(6...8, id: \.self){ index in
                      SquareView(index: index)
                    }
                }
            }.position(x:197,y:-20)
            .overlay{
                if game.isThinking{
                    VStack{
                        ProgressView()
                        Text("Thinking ...")
                        
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                            
                            .font(.title2).bold()
                            .foregroundStyle(Color.indigo)
                       
                    }
                }
            }
            .disabled(game.boardDisabled ||
                      game.gameType == .peer && connectionManger.myPeerId.displayName != game.currentPlayer.name)
            VStack{
                if game.gameOver{
                    Text ("Game Over").padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        
                        .font(.title2).bold()
                        .foregroundStyle(Color.accentColor)
                    if game.possibleMoves.isEmpty{
                        Text("Nobady wins").padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                            
                            .font(.title2).bold()
                            .foregroundStyle(Color.accentColor)
                    }
                    else {
                        Text("\(game.currentPlayer.name) Wins!").padding(.horizontal, 10)
                            .multilineTextAlignment(.center)
                            
                            .font(.title2).bold()
                            .foregroundStyle(Color.accentColor)
                    }
                    Button("New Game"){
                        game.reset()
                        if game.gameType == .peer{
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManger.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(GameButtonStyle())
                }
            }
            .font(.title2)
            Spacer()
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing){
                
                Button("End Game"){
                    dismiss()
                    if game.gameType == .peer{
                        let gameMove = MPGameMove(action: .end, playerName: nil, index: nil)
                        connectionManger.send(gameMove:gameMove)
                    }
                }.buttonStyle(GameButtonStyle())
                    
            }
        }
//            .navigationTitle("TicTacToe By DB")
            .onAppear{
                game.reset()
                if game.gameType == .peer{
                    connectionManger.setup(game: game)
                }
            }
            .inNavigationStack()
    }
}

struct GameView_Previews : PreviewProvider {
        static var previews: some View {
            GameView()
                .environmentObject(GameService())
                .environmentObject(MPConnectionManager(yourName: "Sample"))
        }
    }


//Button Style


struct PlayerButtonStyle : ButtonStyle{
    
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(.systemBackground))
            .foregroundStyle(Color.accentColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  
    }
}




