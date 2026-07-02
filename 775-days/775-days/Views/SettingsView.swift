import SwiftUI

struct SettingsView: View {
    let vm: AppViewModel
    @State private var showingResetAlert = false
    @State private var userName: String = "User"
    @State private var notificationsEnabled: Bool = true
    @State private var selectedTheme: Theme = .system
    @State private var showingEditName = false
    
    enum Theme: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Заголовок
                    VStack(alignment: .leading, spacing: 4) {
                        Text("⚙️ Settings")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        
                        Text("Customize your experience")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 44)
                    
                    // MARK: - Profile Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PROFILE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .kerning(1.5)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        Button {
                            showingEditName = true
                        } label: {
                            HStack(spacing: 14) {
                                // Аватар
                                Circle()
                                    .fill(Color.green.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text(userName.prefix(1).uppercased())
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.green)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(userName)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Text("Tap to edit name")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Preferences Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PREFERENCES")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .kerning(1.5)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        // Notifications
                        SettingsToggleRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Daily reminders for habits",
                            isOn: $notificationsEnabled,
                            iconColor: .blue
                        )
                        
                        // Theme
                        SettingsPickerRow(
                            icon: "moon.fill",
                            title: "Appearance",
                            subtitle: "Choose your theme",
                            options: Theme.allCases.map { $0.rawValue },
                            selectedOption: $selectedTheme,
                            iconColor: .purple
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Data Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DATA")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .kerning(1.5)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Reset Progress",
                            subtitle: "Reset all habits and progress",
                            isDestructive: true
                        ) {
                            showingResetAlert = true
                        }
                        
                        SettingsRow(
                            icon: "square.and.arrow.up",
                            title: "Export Data",
                            subtitle: "Export your progress as JSON"
                        ) {
                            // Экспорт данных
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - About Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ABOUT")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .kerning(1.5)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                        
                        SettingsRow(
                            icon: "info.circle",
                            title: "Version",
                            subtitle: "1.0.0"
                        )
                        
                        SettingsRow(
                            icon: "heart.fill",
                            title: "Made with ❤️",
                            subtitle: "75 Soft Challenge App"
                        ) {
                            // Открыть сайт или социальные сети
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("Are you sure you want to reset all your progress? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditName) {
            EditNameView(userName: $userName)
        }
    }
    
    // MARK: - Functions
    private func resetProgress() {
        // Сброс прогресса
        withAnimation {
            vm.state.currentDay = 0
            vm.state.streak = 0
            vm.state.habits = []
            vm.state.progressPhotos = []
            vm.state.isDayLocked = false
            vm.state.lastCompletedDate = nil
            vm.saveUpdates()
        }
    }
}



// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
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
}

// MARK: - Settings Picker Row
struct SettingsPickerRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let options: [String]
    @Binding var selectedOption: SettingsView.Theme
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Picker("", selection: $selectedOption) {
                ForEach(SettingsView.Theme.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
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
}

// MARK: - Edit Name View
struct EditNameView: View {
    @Binding var userName: String
    @Environment(\.dismiss) var dismiss
    @State private var tempName: String = ""
    
    init(userName: Binding<String>) {
        self._userName = userName
        self._tempName = State(initialValue: userName.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter your name", text: $tempName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.vertical, 8)
                } footer: {
                    Text("This name will be displayed in your profile")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userName = tempName
                        dismiss()
                    }
                    .disabled(tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
