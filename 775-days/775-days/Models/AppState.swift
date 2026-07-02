import Foundation

struct AppState: Codable {
    var currentDay: Int = 0
    var streak: Int = 0
    var startDate: Date = Date()
    var habits: [Habit] = []
    var lastCompletedDate: Date? = nil
    var isDayLocked: Bool = false
    var progressPhotos: [ProgressPhoto] = []  // 👈 добавляем
}

struct ProgressPhoto: Identifiable, Codable {
    let id = UUID()
    let imageData: Data
    let date: Date
    let day: Int
}
