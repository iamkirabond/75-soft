import SwiftUI

struct TodayView: View {
    @Bindable var vm: AppViewModel
    @Binding var showAdd: Bool

    var body: some View {
        ZStack {
            // Мягкий бежевый/кремовый фон
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                    // MARK: - Приветствие
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greetingText())
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        
                        Text(formattedDate())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 44)
                    
                    // MARK: - Soft Challenge Card (белая плашка)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SOFT CHALLENGE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .kerning(1.8)
                            .foregroundColor(.gray)
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("Day \(vm.state.currentDay)")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("of 75")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(vm.state.habits.filter { $0.isCompleted }.count) of \(vm.state.habits.count)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("done")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Прогресс-бар (как на картинке)
                        if vm.state.habits.count > 0 {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.gray.opacity(0.15))
                                        .frame(height: 6)
                                    
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.green)
                                        .frame(
                                            width: geometry.size.width * CGFloat(vm.dailyProgress()),
                                            height: 6
                                        )
                                        .animation(.easeInOut(duration: 0.6), value: vm.dailyProgress())
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.06), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: - Мотивирующая фраза
                    if vm.state.isDayLocked {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Day \(vm.state.currentDay) completed! 🎉")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No streak to break — just small, honest things. Do what you can.")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Список привычек
                    VStack(spacing: 12) {
                        ForEach(vm.state.habits) { habit in
                            HabitCardView(
                                habit: habit,
                                isLocked: vm.state.isDayLocked
                            ) {
                                vm.toggleHabit(habit)
                            }
                            #if os(iOS)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    vm.removeHabit(habit)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            #elseif os(macOS)
                            .contextMenu {
                                Button(role: .destructive) {
                                    vm.removeHabit(habit)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            #endif
                        }
                        
                        // MARK: - Add Your Own
                        Button {
                            showAdd = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Add your own")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Text("A daily thing that matters to you")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
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
                        }
                        .foregroundColor(.primary)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview
#Preview {
    TodayView(vm: AppViewModel(), showAdd: .constant(false))
}
