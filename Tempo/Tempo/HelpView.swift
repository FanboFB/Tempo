import SwiftUI

struct HelpView: View {
    @AppStorage("themeColor") private var themeColor: String = "red"
    
    private var accentColor: Color {
        switch themeColor {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Help")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("How to use this app")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // How to Use
                HelpSection(title: "How to Use", icon: "questionmark.circle.fill") {
                    VStack(alignment: .leading, spacing: 16) {
                        HelpItem(
                            number: "1",
                            title: "Start a Focus Session",
                            description: "Click the play button or press Space to begin your focus session (25 min)."
                        )
                        
                        HelpItem(
                            number: "2",
                            title: "Take a Break",
                            description: "When the focus session ends, a short break starts (5 min). After 4 focus sessions, you'll get a long break (15 min)."
                        )
                        
                        HelpItem(
                            number: "3",
                            title: "Track your Progress",
                            description: "View your statistics to see your daily, weekly, and total focus time. Streaks help keep you motivated!"
                        )
                        
                        HelpItem(
                            number: "4",
                            title: "Customize your Sessions",
                            description: "Use different session presets like 'Deep Work' or 'Quick' and choose whether to auto-start breaks and focus sessions."
                        )
                    }
                }
                
                // Keyboard Shortcuts
                HelpSection(title: "Keyboard Shortcuts", icon: "keyboard.fill") {
                    VStack(spacing: 12) {
                        ShortcutRow(keys: "Space", action: "Start/Pause timer")
                        ShortcutRow(keys: "⌘+R", action: "Stop timer")
                        ShortcutRow(keys: "⌘+S", action: "Skip to next session")
                        ShortcutRow(keys: "⌘+M", action: "Open Mini Player")
                    }
                }
                
                // Tips
                HelpSection(title: "Tips", icon: "lightbulb.fill") {
                    VStack(alignment: .leading, spacing: 12) {
                        TipItem(text: "Use the Mini Player for a compact timer that stays on top of other windows.")
                        TipItem(text: "Customize your focus and break durations in Settings to match your workflow.")
                        TipItem(text: "Enable auto-start options to seamlessly transition between focus sessions and breaks.")
                    }
                }
                
                Spacer()
                    .frame(height: 40)
            }
            .padding(.horizontal)
        }
        .background(Color(.windowBackgroundColor))
    }
}

struct HelpSection<Content: View>: View {
    let title: String
    let icon: String
    @AppStorage("themeColor") private var themeColor: String = "red"
    
    private var accentColor: Color {
        switch themeColor {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .red
        }
    }
    
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.headline)
            }
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}

struct HelpItem: View {
    @AppStorage("themeColor") private var themeColor: String = "red"
    
    private var accentColor: Color {
        switch themeColor {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .red
        }
    }
    
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(accentColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ShortcutRow: View {
    let keys: String
    let action: String
    
    var body: some View {
        HStack {
            Text(keys)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(6)
            
            Text(action)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct TipItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 14))
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
