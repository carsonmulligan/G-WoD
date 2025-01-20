import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var exerciseName = ""
    @State private var notes = ""
    @State private var weight = ""
    @State private var reps = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PlanSectionView(viewModel: viewModel)
                
                LoggingSectionView(
                    viewModel: viewModel,
                    exerciseName: $exerciseName,
                    notes: $notes,
                    weight: $weight,
                    reps: $reps
                )
                
                ActivityLogSectionView(viewModel: viewModel)
            }
            .padding()
        }
        .background(Color(hex: "0D1117"))
        .foregroundColor(Color(hex: "C9D1D9"))
    }
} 