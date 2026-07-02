import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (String) -> Void
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit name", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical, 8)
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !title.isEmpty {
                            onSave(title)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .frame(minWidth: 300, minHeight: 150)
    }
}
