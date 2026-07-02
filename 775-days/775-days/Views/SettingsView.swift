import SwiftUI

struct SettingsView: View {
    @Bindable var vm: AppViewModel
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("⚙️ Settings")
                    .font(.title2)
                    .fontWeight(.light)
                    .padding(.top, 60)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        icon: "person",
                        title: "Profile",
                        subtitle: "Edit your profile"
                    )
                    
                    SettingsRow(
                        icon: "bell",
                        title: "Notifications",
                        subtitle: "Daily reminders"
                    )
                    
                    SettingsRow(
                        icon: "moon",
                        title: "Appearance",
                        subtitle: "Light / Dark mode"
                    )
                    
                    SettingsRow(
                        icon: "arrow.clockwise",
                        title: "Reset Progress",
                        subtitle: "Reset all data",
                        isDestructive: true
                    ) {
                        showingResetAlert = true
                    }
                    
                    SettingsRow(
                        icon: "info",
                        title: "Version",
                        subtitle: "1.0.0"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                // Сброс прогресса
            }
        } message: {
            Text("Are you sure you want to reset all your progress? This action cannot be undone.")
        }
    }
}
