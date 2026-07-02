import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDefault: Bool
    var isCompleted: Bool

    init(title: String, isCompleted: Bool = false, isDefault: Bool ) {
        self.id = UUID()
        self.title = title
        self.isDefault = isDefault
        self.isCompleted = isCompleted
    }
}
