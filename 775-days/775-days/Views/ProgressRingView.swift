import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var label: String
    var size: CGFloat = 160
    var lineWidth: CGFloat = 18
    var accentColor: Color = .primary
    var backgroundColor: Color = Color.gray.opacity(0.12)

    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(
                    accentColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)

            VStack(spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                
                Text("\(Int(round(progress * 100)))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .frame(width: size, height: size)
    }
}
