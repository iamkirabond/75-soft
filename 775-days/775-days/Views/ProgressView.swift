import SwiftUI

struct ProgressView: View {
    @Bindable var vm: AppViewModel

    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Progress")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        
                        Text("75 days challenge")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 44)
                    
                    // MARK: - 75 Days Progress Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("75 DAYS PROGRESS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(1.8)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if vm.state.isDayLocked {
                                Text("🔥 \(vm.state.streak) day streak")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            ProgressRingView(
                                progress: vm.progress(),
                                label: "Days",
                                size: 160,
                                lineWidth: 12,
                                accentColor: .green,
                                backgroundColor: Color.gray.opacity(0.1)
                            )
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("\(vm.state.currentDay)")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("of 75")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(Int(round(vm.progress() * 100)))%")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("complete")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green)
                                    .frame(
                                        width: geometry.size.width * CGFloat(vm.progress()),
                                        height: 6
                                    )
                                    .animation(.easeInOut(duration: 0.6), value: vm.progress())
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.vertical, 20)
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
                    if vm.state.currentDay >= 75 {
                        Text("🎉 Congratulations! You completed the 75 days challenge!")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                            .padding(.horizontal)
                    } else if vm.state.isDayLocked {
                        Text("Keep going! You're on a roll! 🌟")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Text("Small steps lead to big results. Stay consistent! 💪")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Разделитель
                    Divider()
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    
                    // MARK: - Дни
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Journey")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if vm.state.currentDay > 0 {
                            let days = Array(1...vm.state.currentDay).suffix(5)
                            
                            HStack(spacing: 8) {
                                ForEach(days, id: \.self) { day in
                                    VStack(spacing: 4) {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Text("\(day)")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.white)
                                            )
                                        
                                        Text("Day \(day)")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        } else {
                            Text("No days completed yet. Start your journey today! 🌱")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}
