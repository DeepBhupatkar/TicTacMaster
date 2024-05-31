//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by DEEP BHUPATKAR on 24/04/24.
//

import Foundation
import SwiftUI

struct NavStackContainer : ViewModifier    {
    
    func body (content: Content ) -> some View{
        if #available(iOS 16, *){
            NavigationStack{
                content
            }}
        else {
            NavigationView{
                content
            }.navigationViewStyle(.stack)
            
        }
    }
}

extension View {
    public func inNavigationStack () -> some View {
        return self.modifier(NavStackContainer())
    }
}
