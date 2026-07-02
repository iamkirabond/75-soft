import Foundation

class LocalStorage {
    private let key = "75days_state"

    func save(_ state: AppState) {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> AppState {
        if let data = UserDefaults.standard.data(forKey: key),
           let state = try? JSONDecoder().decode(AppState.self, from: data) {
            return state
        }
        return AppState()
    }
}
