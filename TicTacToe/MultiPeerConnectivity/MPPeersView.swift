//
//  MPPeersView.swift
//  TicTacToe
//
//  Created by DEEP BHUPATKAR on 28/04/24.
//

import SwiftUI

struct MPPeersView: View {
    
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game:GameService
    @Binding var startGame : Bool
    var body: some View {
        VStack {
            Text("Availabel Players")
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
//                .position(x:180,y: 50)
                .font(.title3).bold()
                .foregroundStyle(Color.accentColor)
            List(connectionManager.availabelPeers, id: \.self){
                peer in HStack{
                    Text(peer.displayName)
                    Spacer()
                    Button("Select"){
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManager.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(GameButtonStyle())
                }
                .alert("Received Invitation from \(connectionManager.receiverInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receiverInvite)
                {
                    Button("Accept"){
                        if let invitationHandler = connectionManager.invitationHandler{
                            invitationHandler(true, connectionManager.session)
                            game.player1.name = connectionManager.receiverInviteFrom?.displayName ?? "Unknown"
                            game.player2.name = connectionManager.myPeerId.displayName
                            game.gameType = .peer
                        }
                    }
                    Button("Reject"){
                        
                        if let invitationHandler = connectionManager.invitationHandler{
                            invitationHandler(false,nil)
                        }
                           
                    }
                }
             }
        }
        .onAppear{
            connectionManager.isAvailabelToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear{
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailabelToPlay = false
        }
        .onChange(of: connectionManager.paired) {
            newValue in startGame = newValue
        }
    }
}

struct MPPeersView_Previews: PreviewProvider {
    static var previews: some View{
        MPPeersView(startGame : .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
    
}
