import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    
    var body: some View {
        VStack {
            Image("LaunchScreen")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding(.bottom, 20)
            
            Spacer()
            
            Picker("Select Game", selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Two Sharing Device").tag(GameType.single)
                Text("Challenge Your Device").tag(GameType.bot)
                Text("Challenge a Friend").tag(GameType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
            .foregroundColor(.purple)
            
            Text(gameType.description)
                .padding()
            
            VStack {
                switch gameType {
                case .single:
                    TextField("Opponent Name", text: $opponentName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2)
                        )
                        .focused($focus)
                        .frame(width: 350)
                case .bot:
                    EmptyView()
                case .peer:
                    MPPeersView(startGame: $startGame)
                        .environmentObject(connectionManager)
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            
            HStack{  if gameType != .peer {
                Button("     Start Game     ") {
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                    
                }
                .buttonStyle(GameButtonStyle())
                
                .disabled(gameType == .undetermined || (gameType == .single && opponentName.isEmpty))
                
                  
                Button("Change My Name") {
                    changeName.toggle()
                }
                .buttonStyle(GameButtonStyle())
            }
            }
            Spacer()

        }
        .padding()
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField("New Name", text: $newName)
            Button("OK", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Tapping on the OK button will quit the application so you can relaunch to use your changed name.")
        })

    }
}

struct GameButtonStyle: ButtonStyle {
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

struct StartViewPreviews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Hero")
            .environmentObject(GameService())
    }
}
