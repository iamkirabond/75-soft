import SwiftUI

// MARK: - Settings Row (для обычных элементов)
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
