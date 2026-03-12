import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var selectedTab: Int = 0
    
    private var settings: SettingsStore {
        SettingsStore.shared
    }
    
    private var accentColor: Color {
        Color(settings.themeColor)
    }
    
    var body: some View {
        NavigationView {
            SidebarView(selectedTab: $selectedTab)
                .frame(minWidth: 180, idealWidth: 200, maxWidth: 220)
            
            mainContentView
        }
        .navigationTitle("Tempo")
        .accentColor(.blue)
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        ZStack {
            Color(.windowBackgroundColor)
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    TimerView(timerManager: timerManager)
                case 1:
                    StatsView(timerManager: timerManager)
                case 2:
                    SettingsView(timerManager: timerManager, onResetSettings: resetSettings)
                case 3:
                    HelpView()
                default:
                    TimerView(timerManager: timerManager)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func resetSettings() {
        settings.focusDuration = 25
        settings.shortBreakDuration = 5
        settings.longBreakDuration = 15
        settings.autoStartBreaks = true
        settings.autoStartFocus = false
        settings.enableNotifications = true
        settings.enableSounds = true
        settings.themeColor = "red"
    }
}

extension Notification.Name {
    static let timerDataReset = Notification.Name("timerDataReset")
}
