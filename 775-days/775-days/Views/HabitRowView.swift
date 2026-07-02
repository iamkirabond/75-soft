import SwiftUI

struct HabitRowView: View {

    let habit: Habit
    let action: () -> Void

    var body: some View {
        HStack {
            Text(habit.title)
            Spacer()
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}
