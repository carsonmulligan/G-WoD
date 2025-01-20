import Foundation

struct WorkoutDay: Codable {
    let warmUp: String
    let workouts: [String]
    let cardio: String
    
    enum CodingKeys: String, CodingKey {
        case warmUp = "Warm-Up"
        case workouts = "Workouts"
        case cardio = "Cardio"
    }
}

typealias WorkoutPlan = [String: WorkoutDay] 