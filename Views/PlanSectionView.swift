import SwiftUI

struct PlanSectionView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
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
}

#Preview {
    PlanSectionView(viewModel: WorkoutViewModel())
} 