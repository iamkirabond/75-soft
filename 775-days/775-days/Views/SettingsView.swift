import SwiftUI

struct SettingsView: View {
    let vm: AppViewModel
    @State private var showingResetAlert = false
    @State private var userName: String = ""
    @State private var notificationsEnabled: Bool = true
    @State private var selectedTheme: Theme = .system
    @State private var showingEditName = false
    
    enum Theme: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    
    // UserDefaults ключи
    private let userNameKey = "userName"
    private let notificationsKey = "notificationsEnabled"
    private let themeKey = "selectedTheme"
    
    init(vm: AppViewModel) {
        self.vm = vm
        // Загружаем сохранённые настройки
        _userName = State(initialValue: UserDefaults.standard.string(forKey: userNameKey) ?? "User")
        _notificationsEnabled = State(initialValue: UserDefaults.standard.bool(forKey: notificationsKey))
        _selectedTheme = State(initialValue: Theme(rawValue: UserDefaults.standard.string(forKey: themeKey) ?? Theme.system.rawValue) ?? .system)
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
                        
                        SettingsToggleRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Daily reminders for habits",
                            isOn: $notificationsEnabled,
                            iconColor: .blue
                        )
                        .onChange(of: notificationsEnabled) { _, newValue in
                            UserDefaults.standard.set(newValue, forKey: notificationsKey)
                        }
                        
                        SettingsPickerRow(
                            icon: "moon.fill",
                            title: "Appearance",
                            subtitle: "Choose your theme",
                            options: Theme.allCases.map { $0.rawValue },
                            selectedOption: $selectedTheme,
                            iconColor: .purple
                        )
                        .onChange(of: selectedTheme) { _, newValue in
                            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
                            applyTheme(newValue)
                        }
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
                            exportData()
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
                        )
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
            EditNameView(userName: $userName) { newName in
                // Сохраняем имя при изменении
                UserDefaults.standard.set(newName, forKey: userNameKey)
            }
        }
    }
    
    // MARK: - Functions
    private func resetProgress() {
        print("🔄 Resetting progress...")
        
        let defaultHabits = [
            Habit(title: "Water", isCompleted: false, isDefault: true, icon: "drop", color: "blue"),
            Habit(title: "Activity", isCompleted: false, isDefault: true, icon: "dumbbell", color: "orange"),
            Habit(title: "Self development", isCompleted: false, isDefault: true, icon: "book", color: "purple"),
            Habit(title: "Skincare", isCompleted: false, isDefault: true, icon: "sparkles", color: "pink"),
            Habit(title: "Mindfulness", isCompleted: false, isDefault: true, icon: "brain", color: "teal")
        ]
        
        vm.state.currentDay = 0
        vm.state.streak = 0
        vm.state.habits = defaultHabits
        vm.state.progressPhotos = []
        vm.state.isDayLocked = false
        vm.state.lastCompletedDate = nil
        vm.state.startDate = Date()
        
        vm.saveUpdates()
        
        print("✅ Progress reset successfully!")
    }
    
    private func exportData() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(vm.state)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📤 Export Data:\n\(jsonString)")
                
                #if os(iOS)
                let alert = UIAlertController(
                    title: "Export Data",
                    message: "Data exported successfully! Check console for JSON.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(alert, animated: true)
                }
                #endif
            }
        } catch {
            print("❌ Failed to export data: \(error)")
        }
    }
    
    private func applyTheme(_ theme: Theme) {
        // Здесь можно применить тему
        // Для iOS 15+ можно использовать .preferredColorScheme()
        print("🎨 Theme changed to: \(theme.rawValue)")
    }
}

// MARK: - Edit Name View
struct EditNameView: View {
    @Binding var userName: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var tempName: String = ""
    
    init(userName: Binding<String>, onSave: @escaping (String) -> Void) {
        self._userName = userName
        self.onSave = onSave
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
                        let trimmedName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedName.isEmpty {
                            userName = trimmedName
                            onSave(trimmedName)
                            dismiss()
                        }
                    }
                    .disabled(tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isDestructive ? .red : .gray)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(isDestructive ? .red : .primary)
                    
                    Text(subtitle)
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

// MARK: - Preview
#Preview {
    SettingsView(vm: AppViewModel())
}
