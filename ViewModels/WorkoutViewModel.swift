import Foundation
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var selectedDay: String = "Monday (Chest)"
    @Published var currentSets: [WorkoutSet] = []
    @Published var commits: [LocalCommit] = []
    @Published var workoutPlan: WorkoutPlan
    
    private let dataService = LocalDataService()
    
    init() {
        // Load default workout plan from JSON
        if let url = Bundle.main.url(forResource: "DefaultWorkoutPlan", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let plan = try? JSONDecoder().decode(WorkoutPlan.self, from: data) {
            self.workoutPlan = plan
        } else {
            self.workoutPlan = [:]
        }
        
        loadCommits()
    }
    
    func loadCommits() {
        commits = dataService.loadAllCommits()
    }
    
    func addSet(exerciseName: String, notes: String?, weight: String, reps: Int) {
        let set = WorkoutSet(exerciseName: exerciseName, notes: notes, weight: weight, reps: reps)
        currentSets.append(set)
    }
    
    func commitSession() {
        guard !currentSets.isEmpty else { return }
        
        let markdown = dataService.generateMarkdownFromSets(currentSets)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "workout-\(dateFormatter.string(from: Date())).md"
        
        let commit = LocalCommit(
            message: "Completed workout for \(selectedDay)",
            fileName: fileName,
            content: markdown
        )
        
        dataService.saveCommit(commit)
        currentSets.removeAll()
        loadCommits()
    }
    
    func commitsForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return commits.filter {
            calendar.isDate($0.timestamp, inSameDayAs: date)
        }.count
    }
} 