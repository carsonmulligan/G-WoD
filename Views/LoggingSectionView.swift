import SwiftUI

struct LoggingSectionView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var exerciseName: String
    @Binding var notes: String
    @Binding var weight: String
    @Binding var reps: Int
    
    var body: some View {
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
} 