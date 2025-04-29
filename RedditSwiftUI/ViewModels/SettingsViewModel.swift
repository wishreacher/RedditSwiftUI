import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var wrongUsername: Bool = false
    @Published var username: String = "" {
        didSet {
            validateUsername()
        }
    }
    
    @ViewBuilder
    func wrongInputLabel() -> some View {
        Text("User name should be between 5 and 10 symbols")
            .foregroundColor(.red)
            .font(.footnote)
            .opacity(wrongUsername ? 1 : 0)
    }

    func validateUsername() {
        if username.count < 5 || username.count > 10 {
            wrongUsername = true
        } else {
            wrongUsername = false
            saveUser(User(name: username))
        }
    }

    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }
}
