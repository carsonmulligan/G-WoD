import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var exerciseName = ""
    @State private var notes = ""
    @State private var weight = ""
    @State private var reps = 1
    
    private let colors: [Int: Color] = [
        0: Color(hex: "0D1117"),
        1: Color(hex: "0E4429"),
        4: Color(hex: "006D32"),
        6: Color(hex: "26A641"),
        9: Color(hex: "39D353")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Plan Section
                planSection
                
                // Logging Section
                loggingSection
                
                // Activity Log Section
                activityLogSection
            }
            .padding()
        }
        .background(Color(hex: "0D1117"))
        .foregroundColor(Color(hex: "C9D1D9"))
    }
    
    private var planSection: some View {
        VStack(alignment: .leading) {
            Text("Weekly Plan")
                .font(.title)
            
            ForEach(Array(viewModel.workoutPlan.keys.sorted()), id: \.self) { day in
                Button(action: { viewModel.selectedDay = day }) {
                    Text(day)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(viewModel.selectedDay == day ? Color(hex: "0E4429") : Color.clear)
                        .cornerRadius(8)
                }
            }
            
            if let selectedDayPlan = viewModel.workoutPlan[viewModel.selectedDay] {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Warm-Up:").font(.headline)
                    Text(selectedDayPlan.warmUp)
                    
                    Text("Workouts:").font(.headline)
                    ForEach(selectedDayPlan.workouts, id: \.self) { workout in
                        Text("• \(workout)")
                    }
                    
                    Text("Cardio:").font(.headline)
                    Text(selectedDayPlan.cardio)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
            }
        }
    }
    
    private var loggingSection: some View {
        VStack {
            Text("Log Workout")
                .font(.title)
            
            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Notes (optional)", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Weight (e.g., '50 lbs')", text: $weight)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Stepper("Reps: \(reps)", value: $reps, in: 1...50)
            
            Button("Add Set") {
                viewModel.addSet(
                    exerciseName: exerciseName,
                    notes: notes.isEmpty ? nil : notes,
                    weight: weight,
                    reps: reps
                )
                exerciseName = ""
                notes = ""
                weight = ""
                reps = 1
            }
            .disabled(exerciseName.isEmpty || weight.isEmpty)
            
            Button("Commit Session") {
                viewModel.commitSession()
            }
            .disabled(viewModel.currentSets.isEmpty)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
    
    private var activityLogSection: some View {
        VStack {
            Text("Activity Log")
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(-51...0, id: \.self) { weekOffset in
                        VStack(spacing: 4) {
                            ForEach(0..<7, id: \.self) { dayOffset in
                                let date = Calendar.current.date(byAdding: .day, value: weekOffset * 7 + dayOffset, to: Date()) ?? Date()
                                let commits = viewModel.commitsForDate(date)
                                
                                Rectangle()
                                    .fill(colorForCommits(commits))
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(2)
                            }
                        }
                    }
                }
            }
            
            // Legend
            HStack {
                ForEach(Array(colors.sorted { $0.key < $1.key }), id: \.key) { count, color in
                    HStack {
                        Rectangle()
                            .fill(color)
                            .frame(width: 10, height: 10)
                            .cornerRadius(2)
                        Text(legendText(for: count))
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
    
    private func colorForCommits(_ count: Int) -> Color {
        for (threshold, color) in colors.sorted(by: { $0.key > $1.key }) {
            if count >= threshold {
                return color
            }
        }
        return colors[0] ?? Color.clear
    }
    
    private func legendText(for count: Int) -> String {
        switch count {
        case 0: return "0"
        case 1: return "1-3"
        case 4: return "4-5"
        case 6: return "6-8"
        case 9: return "9+"
        default: return ""
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 