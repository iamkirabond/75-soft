import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String          // ✅ теперь var
    var isCompleted: Bool
    let isDefault: Bool
    var icon: String
    var color: String
    
    init(title: String, isCompleted: Bool = false, isDefault: Bool, icon: String = "circle", color: String = "blue") {
        self.title = title
        self.isCompleted = isCompleted
        self.isDefault = isDefault
        self.icon = icon
        self.color = color
    }
}
