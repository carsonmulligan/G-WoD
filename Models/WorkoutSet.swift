import Foundation

struct WorkoutSet: Codable, Identifiable {
    let id: UUID
    let exerciseName: String
    let notes: String?
    let weight: String
    let reps: Int
    let date: Date
    
    init(exerciseName: String, notes: String? = nil, weight: String, reps: Int, date: Date = Date()) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.notes = notes
        self.weight = weight
        self.reps = reps
        self.date = date
    }
} 