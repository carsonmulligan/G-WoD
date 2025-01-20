import Foundation

class LocalDataService {
    private let fileManager = FileManager.default
    private let commitsDirectory: URL
    
    init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        commitsDirectory = documentsDirectory.appendingPathComponent("commits")
        try? fileManager.createDirectory(at: commitsDirectory, withIntermediateDirectories: true)
    }
    
    func loadAllCommits() -> [LocalCommit] {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: commitsDirectory, includingPropertiesForKeys: nil)
            return try fileURLs.compactMap { url in
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(LocalCommit.self, from: data)
            }
        } catch {
            print("Error loading commits: \(error)")
            return []
        }
    }
    
    func saveCommit(_ localCommit: LocalCommit) {
        do {
            let fileURL = commitsDirectory.appendingPathComponent("\(localCommit.id).json")
            let data = try JSONEncoder().encode(localCommit)
            try data.write(to: fileURL)
        } catch {
            print("Error saving commit: \(error)")
        }
    }
    
    func generateMarkdownFromSets(_ sets: [WorkoutSet]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        var markdown = "# Workout Session - \(dateFormatter.string(from: Date()))\n\n"
        
        for set in sets {
            markdown += "## \(set.exerciseName)\n"
            markdown += "- Weight: \(set.weight)\n"
            markdown += "- Reps: \(set.reps)\n"
            if let notes = set.notes {
                markdown += "- Notes: \(notes)\n"
            }
            markdown += "\n"
        }
        
        return markdown
    }
} 