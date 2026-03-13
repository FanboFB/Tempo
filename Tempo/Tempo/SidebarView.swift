//  Tempo - Sidebar View
//  Navigation sidebar with app branding and menu items

import SwiftUI

struct SidebarView: View {
    @Binding var selectedTab: Int
    @Namespace private var namespace
    
    // @AppStorage for reactive theme color updates
    @AppStorage("themeColor") private var themeColorValue: String = "red"
    
    // MARK: - Computed Properties
    // Convert string theme color to SwiftUI Color
    private var accentColor: Color {
        switch themeColorValue {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .red
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // App Header
            appHeader
            
            // Navigation Items
            navigationItems
            
            Spacer()
            
            // Mini Player shortcut
            miniPlayerButton
            
            // Version indicator
            versionIndicator
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                .ignoresSafeArea()
        )
    }
    
    // MARK: - View Components
    private var appHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                // App icon with gradient
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(accentColor.gradient)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "timer")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Tempo")
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .padding(.bottom, 8)
    }
    
    private var navigationItems: some View {
        VStack(spacing: 4) {
            SidebarItem(
                title: "Timer",
                icon: "timer",
                isSelected: selectedTab == 0,
                accentColor: accentColor,
                namespace: namespace
            )
            .onTapGesture { selectTab(0) }
            
            SidebarItem(
                title: "Statistics",
                icon: "chart.bar.fill",
                isSelected: selectedTab == 1,
                accentColor: accentColor,
                namespace: namespace
            )
            .onTapGesture { selectTab(1) }
            
            SidebarItem(
                title: "Settings",
                icon: "gearshape.fill",
                isSelected: selectedTab == 2,
                accentColor: accentColor,
                namespace: namespace
            )
            .onTapGesture { selectTab(2) }
            
            SidebarItem(
                title: "Help",
                icon: "questionmark.circle.fill",
                isSelected: selectedTab == 3,
                accentColor: accentColor,
                namespace: namespace
            )
            .onTapGesture { selectTab(3) }
        }
        .padding(.horizontal, 10)
        .padding(.top, 8)
    }
    
    private var miniPlayerButton: some View {
        Button(action: {
            NotificationCenter.default.post(name: .openMiniPlayer, object: nil)
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.compress.vertical")
                    .font(.system(size: 12, weight: .medium))
                Text("Mini Player")
                    .font(.system(size: 12, weight: .medium))
                Spacer()
                Text("⌘M")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
        .keyboardShortcut("m", modifiers: .command)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
    
    private var versionIndicator: some View {
        HStack {
            Circle()
                .fill(accentColor)
                .frame(width: 6, height: 6)
                .shadow(color: accentColor.opacity(0.5), radius: 2)
            
            Text("v1.2.1")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    // MARK: - Helper Methods
    private func selectTab(_ index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            selectedTab = index
        }
    }
}

// MARK: - Sidebar Item
struct SidebarItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let accentColor: Color
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 20)
                .foregroundColor(isSelected ? .white : .secondary)
            
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .primary)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accentColor)
                        .matchedGeometryEffect(id: "tab", in: namespace)
                }
            }
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Visual Effect View
/// NSViewRepresentable for applying macOS visual effect materials
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
