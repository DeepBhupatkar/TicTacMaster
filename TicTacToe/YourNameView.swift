//
//  YourNameView.swift
//  TicTacToe
//
//  Created by DEEP BHUPATKAR on 26/04/24.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    
    var body: some View {
        VStack {
            Image("LaunchScreen")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .padding(.bottom, 20)
            
            Spacer()
            
            Text("This is the name that will be associated with this device.")
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .position(x:180,y: 50)
                .font(.title2).bold()
                .foregroundStyle(Color.accentColor)
            
            TextField("Your Name", text: $userName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 2) // TextField border color and width
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            Button(action: {
                yourName = userName
            }) {
                Text("Change Name")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .disabled(userName.isEmpty)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 2) // Button border color and width
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .padding()
       
    }
}

#Preview {
    YourNameView()
}
