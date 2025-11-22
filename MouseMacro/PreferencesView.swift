import SwiftUI

/// Thread-safe singleton state for preferences UI updates
@MainActor
final class PreferencesState: ObservableObject {
    static let shared = PreferencesState()
    
    @Published var lastAction: String = "Waiting for button press..."
    @Published var copyCount: Int = 0
    @Published var pasteCount: Int = 0
    
    private init() {}
    
    func recordCopy() {
        copyCount += 1
        lastAction = "Button 4 → ⌘ + C (Total: \(copyCount))"
    }
    
    func recordPaste() {
        pasteCount += 1
        lastAction = "Button 5 → ⌘ + V (Total: \(pasteCount))"
    }
    
    func reset() {
        copyCount = 0
        pasteCount = 0
        lastAction = "Statistics reset"
    }
}

struct PreferencesView: View {
    @StateObject private var state = PreferencesState.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("MouseMacro Configuration")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Mouse button shortcuts active")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Current Mappings
            VStack(alignment: .leading, spacing: 12) {
                Text("🎯 Active Shortcuts")
                    .font(.headline)
                
                HStack {
                    Text("Button 4")
                        .fontWeight(.medium)
                        .frame(width: 80, alignment: .leading)
                    Text("→")
                        .foregroundColor(.secondary)
                    Text("⌘ + C")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Text("(Copy)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                HStack {
                    Text("Button 5")
                        .fontWeight(.medium)
                        .frame(width: 80, alignment: .leading)
                    Text("→")
                        .foregroundColor(.secondary)
                    Text("⌘ + V")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Text("(Paste)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            Divider()
            
            // Statistics
            VStack(alignment: .leading, spacing: 12) {
                Text("📊 Session Statistics")
                    .font(.headline)
                
                HStack {
                    Text("Copies:")
                        .foregroundColor(.secondary)
                    Text("\(state.copyCount)")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("Pastes:")
                        .foregroundColor(.secondary)
                    Text("\(state.pasteCount)")
                        .fontWeight(.semibold)
                }
                
                Text(state.lastAction)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            // Footer
            HStack {
                Text("Original button actions are disabled")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Reset Stats") {
                    state.reset()
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
        }
        .padding(24)
        .frame(width: 400, height: 240)
    }
}
