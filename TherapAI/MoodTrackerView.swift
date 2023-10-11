import SwiftUI

// Define the Mood enum here
enum Mood: String, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case neutral = "Neutral"
    case angry = "Angry"
    case excited = "Excited"
}

extension Mood {
    var color: UIColor {
        switch self {
        case .happy:
            return .green
        case .sad:
            return .blue
        case .neutral:
            return .gray
        case .angry:
            return .red
        case .excited:
            return .yellow
        }
    }
}
struct BarChartDataEntry {
    var date: Date
    var value: Int
}

struct MoodTrackerView: View {
    @State private var selectedMoods: [Mood] = []
    @State private var moodsSubmitted = false
    @State private var viewType: GraphTimeframe = .weekly

    // SwiftCharts Data
    @State private var weeklyData: [(Date, Int)] = []
    @State private var monthlyData: [(Date, Int)] = []


    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    enum GraphTimeframe {
        case weekly, monthly
    }

    var body: some View {
        VStack {
            titleText
            if !moodsSubmitted {
                moodSelectionView
                submitButton
            } else {
                moodChartPicker
                moodChart
            }
        }
        .padding()
        .onAppear(perform: loadData)
    }
    
    var titleText: some View {
        Text(moodsSubmitted ? "Your mood insights" : "How are you feeling today?")
            .font(.title2)
            .padding(.bottom, 20)
    }
    
    var moodSelectionView: some View {
        HStack(spacing: 10) {
            ForEach(Mood.allCases, id: \.self) { mood in
                Button(action: {
                    toggleMood(mood)
                }) {
                    Text(mood.rawValue)
                        .padding(10)
                        .background(selectedMoods.contains(mood) ? Color(mood.color) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.vertical, 10)
    }

    var submitButton: some View {
        Button("Submit", action: submitMoods)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
    }

    var moodChartPicker: some View {
        Picker("", selection: $viewType) {
            Text("Weekly").tag(GraphTimeframe.weekly)
            Text("Monthly").tag(GraphTimeframe.monthly)
        }.pickerStyle(SegmentedPickerStyle())
    }

    var moodChart: some View {
        if viewType == .weekly {
            moodChartView(data: $weeklyData)
        } else {
            moodChartView(data: $monthlyData)
        }
    }
    
    func moodChartView(data: Binding<[(Date, Int)]>)-> some View {
        let chartData = data.wrappedValue.map { BarChartDataEntry(date: $0.0, value: $0.1) }
        return BarChartView(entries: chartData).padding()
    }

    func loadData() {
        checkIfMoodsSubmittedToday()
        fetchMoodData(for: .weekly)
        fetchMoodData(for: .monthly)
    }
    
    func toggleMood(_ mood: Mood) {
        if let index = selectedMoods.firstIndex(of: mood) {
            selectedMoods.remove(at: index)
        } else {
            selectedMoods.append(mood)
        }
    }

    func checkIfMoodsSubmittedToday() {
        APIManager.shared.hasSubmittedMoodToday { (hasSubmitted) in
            DispatchQueue.main.async {
                self.moodsSubmitted = hasSubmitted
            }
        }
    }

    func fetchMoodData(for timeframe: GraphTimeframe) {
        APIManager.shared.fetchMoods(timeframe: timeframe) { moodData in
            let sortedMoodData = moodData.sorted(by: { $0.date < $1.date }).map { (date: dateFormatter.date(from: $0.date) ?? Date(), count: $0.count) }

            if timeframe == .weekly {
                self.weeklyData = sortedMoodData
            } else {
                self.monthlyData = sortedMoodData
            }
        }
    }


    func submitMoods() {
        APIManager.shared.saveMood(moods: selectedMoods.map { $0.rawValue }) { success in
            if success {
                self.moodsSubmitted = true
            } else {
                // Handle the error, e.g. show an alert to the user
            }
        }
    }
}
