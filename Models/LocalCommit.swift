import Foundation

struct LocalCommit: Codable, Identifiable {
    let id: UUID
    let message: String
    let timestamp: Date
    let fileName: String
    let content: String
    
    init(message: String, fileName: String, content: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.message = message
        self.fileName = fileName
        self.content = content
        self.timestamp = timestamp
    }
} 