import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    let isLocked: Bool
    let action: () -> Void
    let onEdit: () -> Void   // 👈 параметр для редактирования
    
    // Конвертируем строку в Color
    private var habitColor: Color {
        switch habit.color {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        case "pink": return .pink
        case "teal": return .teal
        case "mint": return .mint
        case "indigo": return .indigo
        case "yellow": return .yellow
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Иконка привычки
            Image(systemName: habit.icon)
                .font(.system(size: 18))
                .foregroundColor(habit.isCompleted ? .green : habitColor)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(habit.isCompleted ? Color.green.opacity(0.15) : habitColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                )
            
            // Текст привычки
            VStack(alignment: .leading, spacing: 3) {
                Text(habit.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .strikethrough(habit.isCompleted && isLocked, color: .gray)
                
                // Подпись для дефолтных привычек
                if habit.isDefault {
                    Text(habitSubtitle(for: habit.title))
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Статус выполнения (галочка или круг)
            if habit.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.green)
            } else if isLocked {
                Image(systemName: "circle")
                    .font(.system(size: 22))
                    .foregroundColor(.gray.opacity(0.3))
            } else {
                Image(systemName: "circle")
                    .font(.system(size: 22))
                    .foregroundColor(habitColor.opacity(0.4))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(habit.isCompleted && !isLocked ? Color.green.opacity(0.3) : Color.gray.opacity(0.06), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if !isLocked {
                action()
            }
        }
        .onLongPressGesture(minimumDuration: 0.5) {
            if !isLocked {
                onEdit()   // 👈 вызываем редактирование
            }
        }
    }
    
    // MARK: - Colors
    var textColor: Color {
        if isLocked {
            return habit.isCompleted ? .gray.opacity(0.5) : .gray.opacity(0.6)
        } else {
            return .primary
        }
    }
    
    // MARK: - Helpers (75 Soft подписи)
    private func habitSubtitle(for title: String) -> String {
        switch title {
        case "Move your body":
            return "A 20-minute walk counts"
        case "Drink water":
            return "Six glasses through the day"
        case "Read":
            return "Ten pages — fiction is fine"
        case "Healthy eating":
            return "Eat well, feel well"
        case "Progress photo":
            return "Today's gentle snapshot"
        default:
            return ""
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        HabitCardView(
            habit: Habit(title: "Move your body", isCompleted: false, isDefault: true, icon: "figure.walk", color: "orange"),
            isLocked: false,
            action: {},
            onEdit: {}
        )
        
        HabitCardView(
            habit: Habit(title: "Drink water", isCompleted: true, isDefault: true, icon: "drop", color: "blue"),
            isLocked: false,
            action: {},
            onEdit: {}
        )
    }
    .padding()
    .background(Color(red: 0.98, green: 0.97, blue: 0.94))
    .previewLayout(.sizeThatFits)
}
