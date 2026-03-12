import SwiftUI

// MARK: - Mini Player View
/// Compact floating timer window that stays on top of other apps
struct MiniPlayerView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var dragOffset: CGSize = .zero
    
    // MARK: - Computed Properties
    private var themeColor: String { SettingsStore.shared.themeColor }
    private var accentColor: Color { themeColor.themeColor }
    
    var body: some View {
        HStack(spacing: 16) {
            // Session info
            sessionInfo
            
            Spacer()
            
            // Timer display
            Text(timeString(from: timerManager.timeRemaining))
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(accentColor)
            
            Spacer()
            
            // Controls
            controlButtons
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor))
        .background(DraggableView())
    }
    
    // MARK: - View Components
    private var sessionInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Session: \(timerManager.currentSessionName.isEmpty ? "Focus" : timerManager.currentSessionName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var controlButtons: some View {
        HStack(spacing: 8) {
            Button(action: { timerManager.stop() }) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 12))
            }
            .buttonStyle(.borderless)
            
            Button(action: { timerManager.togglePlayPause() }) {
                Image(systemName: timerManager.state == .running ? "pause.fill" : "play.fill")
                    .font(.system(size: 14))
            }
            .buttonStyle(.borderless)
            
            Button(action: { timerManager.skip() }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 12))
            }
            .buttonStyle(.borderless)
            
            Button(action: closeWindow) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.borderless)
        }
    }
    
    // MARK: - Helper Methods
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func closeWindow() {
        NSApp.windows.first { $0.title == "Mini Player" }?.close()
    }
}

// MARK: - Draggable View
/// Allows the mini player window to be dragged anywhere
struct DraggableView: NSViewRepresentable {
    func makeNSView(context: Context) -> DraggableNSView {
        DraggableNSView()
    }
    
    func updateNSView(_ nsView: DraggableNSView, context: Context) {}
}

class DraggableNSView: NSView {
    override var mouseDownCanMoveWindow: Bool { true }
}
