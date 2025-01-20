import SwiftUI

struct ActivityLogSectionView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    private let colors: [Int: Color] = [
        0: Color(hex: "0D1117"),
        1: Color(hex: "0E4429"),
        4: Color(hex: "006D32"),
        6: Color(hex: "26A641"),
        9: Color(hex: "39D353")
    ]
    
    var body: some View {
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