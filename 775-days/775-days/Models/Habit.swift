import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
    let isDefault: Bool
    var icon: String = "circle"      // 👈 добавляем иконку
    var color: String = "blue"       // 👈 добавляем цвет (храним как строку)
    
    init(title: String, isCompleted: Bool = false, isDefault: Bool, icon: String = "circle", color: String = "blue") {
        self.title = title
        self.isCompleted = isCompleted
        self.isDefault = isDefault
        self.icon = icon
        self.color = color
    }
}
