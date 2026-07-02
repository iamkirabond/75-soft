import SwiftUI

struct MainView: View {
    @State private var vm = AppViewModel()
    @State private var showAdd = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            #if os(macOS)
            // Для macOS используем стандартный TabView
            TabView(selection: $selectedTab) {
                TodayView(vm: vm, showAdd: $showAdd)
                    .tabItem { Label("Today", systemImage: "list.bullet") }
                    .tag(0)
                
                ProgressView(vm: vm)
                    .tabItem { Label("Progress", systemImage: "chart.bar") }
                    .tag(1)
                
                PhotosView(vm: vm)
                    .tabItem { Label("Photos", systemImage: "photo") }
                    .tag(2)
                
                SettingsView(vm: vm)
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .tag(3)
            }
            #else
            // Для iOS используем кастомный таб-бар
            TabView(selection: $selectedTab) {
                TodayView(vm: vm, showAdd: $showAdd)
                    .tag(0)
                
                ProgressView(vm: vm)
                    .tag(1)
                
                PhotosView(vm: vm)
                    .tag(2)
                
                SettingsView(vm: vm)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .bottom)
            #endif
            
            // Кастомный таб-бар (только для iOS)
            #if os(iOS)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "list.bullet",
                        title: "Today",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    
                    TabBarButton(
                        icon: "chart.bar",
                        title: "Progress",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    
                    TabBarButton(
                        icon: "photo",
                        title: "Photos",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    
                    TabBarButton(
                        icon: "gear",
                        title: "Settings",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -2)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            #endif
        }
        .sheet(isPresented: $showAdd) {
            AddHabitView { title, icon, color in
                vm.addHabit(title: title, icon: icon, color: color)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
