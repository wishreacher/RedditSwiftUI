//
//  SettingsView.swift
//  RedditSwiftUI
//
//  Created by Володимир on 10.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    @State var username: String = ""
    
    var body: some View {
        VStack{
            userSettings()
            vm.wrongInputLabel()
        }
    }
    
    @ViewBuilder
    func userSettings() -> some View {
        VStack {
            Text("Your username:")
                .bold()
                .font(.title)

            TextField("username", text: $vm.username)
                .frame(width: 300, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SettingsView()
}
