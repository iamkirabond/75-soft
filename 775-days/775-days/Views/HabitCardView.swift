import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Круглый чекбокс
            Button {
                if !isLocked {
                    action()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(checkboxBackgroundColor)
                        .frame(width: 28, height: 28)
                    
                    if habit.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(isLocked)
            .buttonStyle(PlainButtonStyle())
            
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
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.06), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if !isLocked {
                action()
            }
        }
    }
    
    // MARK: - Colors
    var checkboxBackgroundColor: Color {
        if habit.isCompleted {
            return Color.green
        } else if isLocked {
            return Color.gray.opacity(0.2)
        } else {
            return Color.gray.opacity(0.12)
        }
    }
    
    var textColor: Color {
        if isLocked {
            return habit.isCompleted ? .gray.opacity(0.5) : .gray.opacity(0.6)
        } else {
            return .primary
        }
    }
    
    // MARK: - Helpers
    private func habitSubtitle(for title: String) -> String {
        switch title {
        case "Water":
            return "Six glasses through the day"
        case "Activity":
            return "A 20-minute walk counts"
        case "Self development":
            return "Five pages — fiction is fine"
        case "Skincare":
            return "A little care goes a long way"
        case "Mindfulness":
            return "Five minutes just for you"
        default:
            return ""
        }
    }
}
