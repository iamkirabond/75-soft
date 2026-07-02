import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (String, String, String) -> Void  // 👈 изменено: (title, icon, color)
    
    @State private var title = ""
    @State private var selectedIcon = "star"
    @State private var selectedColor: Color = .blue
    @State private var habitDescription = ""
    @State private var showingIconPicker = false
    
    // Доступные иконки для привычек
    private let icons = [
        "star", "heart", "book", "dumbbell", "leaf", "moon",
        "sun.max", "drop", "figure.walk", "bed.double", "pencil",
        "flame", "sparkles", "brain", "cup.and.saucer", "bicycle",
        "music.note", "camera", "globe", "hands.sparkles"
    ]
    
    private let colors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink,
        .teal, .mint, .indigo, .yellow
    ]
    
    // Конвертируем Color в строку для сохранения
    private func colorToString(_ color: Color) -> String {
        switch color {
        case .blue: return "blue"
        case .green: return "green"
        case .orange: return "orange"
        case .red: return "red"
        case .purple: return "purple"
        case .pink: return "pink"
        case .teal: return "teal"
        case .mint: return "mint"
        case .indigo: return "indigo"
        case .yellow: return "yellow"
        default: return "blue"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.97, blue: 0.94)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Иконка и название
                        VStack(spacing: 16) {
                            // Круг с иконкой
                            Button {
                                showingIconPicker.toggle()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(selectedColor.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: selectedIcon)
                                        .font(.system(size: 32))
                                        .foregroundColor(selectedColor)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(showingIconPicker ? "Choose an icon" : "Tap icon to change")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // MARK: - Название привычки
                        VStack(alignment: .leading, spacing: 8) {
                            Text("HABIT NAME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(1.5)
                                .foregroundColor(.gray)
                            
                            TextField("e.g. Morning Meditation", text: $title)
                                .font(.headline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.gray.opacity(0.06), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Описание
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DESCRIPTION (OPTIONAL)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(1.5)
                                .foregroundColor(.gray)
                            
                            TextField("Add a short description", text: $habitDescription)
                                .font(.subheadline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.gray.opacity(0.06), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Цвет
                        VStack(alignment: .leading, spacing: 8) {
                            Text("COLOR")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(1.5)
                                .foregroundColor(.gray)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(colors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 2)
                                                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                            )
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3)) {
                                                    selectedColor = color
                                                }
                                            }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Иконки
                        if showingIconPicker {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ICONS")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .kerning(1.5)
                                    .foregroundColor(.gray)
                                
                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible()), count: 8),
                                    spacing: 8
                                ) {
                                    ForEach(icons, id: \.self) { icon in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedIcon = icon
                                                showingIconPicker = false
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.clear)
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: icon)
                                                    .font(.system(size: 18))
                                                    .foregroundColor(selectedIcon == icon ? selectedColor : .gray)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .scale))
                        }
                        
                        // MARK: - Кнопка сохранения
                        Button {
                            if !title.isEmpty {
                                let colorString = colorToString(selectedColor)
                                onSave(title, selectedIcon, colorString)  // 👈 передаём 3 аргумента
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Add Habit")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(title.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                            )
                            .foregroundColor(title.isEmpty ? .gray : .white)
                        }
                        .padding(.horizontal)
                        .disabled(title.isEmpty)
                        
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    AddHabitView { title, icon, color in
        print("Added habit: \(title) with icon: \(icon) and color: \(color)")
    }
}
