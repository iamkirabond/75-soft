import Observation
import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@Observable
class AppViewModel {
    var state = AppState()
    private let storage = LocalStorage()
    private let calendar = Calendar.current

    init() {
        state = storage.load()
        checkDayReset()
        setupDefaultsIfNeeded()
    }

    // MARK: - Setup
    private func setupDefaultsIfNeeded() {
        if state.habits.isEmpty {
            state.habits = [
                Habit(title: "Water", isCompleted: false, isDefault: true),
                Habit(title: "Activity", isCompleted: false, isDefault: true),
                Habit(title: "Self development", isCompleted: false, isDefault: true),
                Habit(title: "Skincare", isCompleted: false, isDefault: true),
                Habit(title: "Mindfulness", isCompleted: false, isDefault: true)
            ]
            save()
        }
    }

    private func checkDayReset() {
        if let lastDate = state.lastCompletedDate,
           !calendar.isDateInToday(lastDate) {
            state.isDayLocked = false
            for i in state.habits.indices {
                state.habits[i].isCompleted = false
            }
            save()
        }
    }

    // MARK: - Habit logic
    func toggleHabit(_ habit: Habit) {
        guard !state.isDayLocked else { return }
        guard let index = state.habits.firstIndex(where: { $0.id == habit.id }) else { return }
        state.habits[index].isCompleted.toggle()
        save()
        
        if isDayCompleted() {
            completeDay()
        }
    }

    func addHabit(title: String) {
        let newHabit = Habit(
            title: title,
            isCompleted: false,
            isDefault: false
        )
        state.isDayLocked = false
        state.habits.append(newHabit)
        save()
    }
    
    func removeHabit(_ habit: Habit) {
        guard let index = state.habits.firstIndex(where: { $0.id == habit.id }) else { return }
        state.habits.remove(at: index)
        
        if state.habits.isEmpty {
            state.isDayLocked = false
            state.lastCompletedDate = nil
        }
        
        save()
    }
    
    // MARK: - Photo logic
    func addPhoto(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let photo = ProgressPhoto(
            imageData: imageData,
            date: Date(),
            day: state.currentDay
        )
        
        state.progressPhotos.append(photo)
        save()
    }
    
    func removePhoto(_ photo: ProgressPhoto) {
        guard let index = state.progressPhotos.firstIndex(where: { $0.id == photo.id }) else { return }
        state.progressPhotos.remove(at: index)
        save()
    }
    
    func getPhotoImage(_ photo: ProgressPhoto) -> UIImage? {
        return UIImage(data: photo.imageData)
    }

    func isDayCompleted() -> Bool {
        guard !state.habits.isEmpty else { return false }
        return state.habits.allSatisfy { $0.isCompleted }
    }

    private func completeDay() {
        guard !state.isDayLocked else { return }
        guard isDayCompleted() else { return }
        
        if let lastDate = state.lastCompletedDate,
           calendar.isDateInToday(lastDate) {
            return
        }
        
        state.currentDay += 1
        state.streak += 1
        state.lastCompletedDate = Date()
        state.isDayLocked = true
        
        save()
        print("✅ Day \(state.currentDay) completed automatically!")
    }

    // MARK: - Save
    private func save() {
        storage.save(state)
    }

    // MARK: - Progress
    func progress() -> Double {
        return Double(state.currentDay) / 75.0
    }

    func dailyProgress() -> Double {
        guard !state.habits.isEmpty else { return 0 }
        let completed = state.habits.filter { $0.isCompleted }.count
        return Double(completed) / Double(state.habits.count)
    }
    // MARK: - Save
    func saveUpdates() {
        storage.save(state)
    }
}
