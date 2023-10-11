//
//  BarChartView.swift
//  TherapAI
//
//  Created by Iman Shalizi on 10/10/23.
//

import SwiftUI

struct BarChartView: View {
    var entries: [BarChartDataEntry]
    let maxBarHeight: CGFloat = 300
    var maxValue: Int {
        entries.map { $0.value }.max() ?? 0
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(entries, id: \.date) { entry in
                VStack {
                    Text("\(entry.value)")
                        .font(.footnote)
                        .rotationEffect(.degrees(-45))
                        .position(x: 50, y: 0)
                        .zIndex(1)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(entry.value) / CGFloat(self.maxValue) * self.maxBarHeight)
                    Text(dateFormatter.string(from: entry.date))
                        .font(.footnote)
                        .rotationEffect(.degrees(-45))
                        .position(x: 50, y: 10)
                        .zIndex(1)
                }
            }
        }
    }
}
