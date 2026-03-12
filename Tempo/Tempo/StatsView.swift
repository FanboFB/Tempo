//  Tempo - Statistics View
//  Displays user's productivity statistics and insights

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var timerManager: TimerManager
    
    // MARK: - Computed Properties
    private var themeColor: String { SettingsStore.shared.themeColor }
    private var accentColor: Color { themeColor.themeColor }
    
    private var weeklyData: [TimerManager.DailyStat] { timerManager.getWeeklyData() }
    
    private var totalSessionsThisWeek: Int {
        weeklyData.reduce(0) { $0 + $1.sessions }
    }
    
    /// Formats total focus time as "Xh Ym" or "Ym" if less than an hour
    private var totalTimeString: String {
        let totalSeconds = Int(timerManager.totalFocusTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerSection
                
                // Quick Stats Grid
                statsGrid
                
                // Weekly Chart
                if !weeklyData.isEmpty {
                    weeklyChart
                }
                
                // Insights Section
                insightsSection
                
                Spacer().frame(height: 40)
            }
            .padding(.horizontal)
        }
        .background(Color(.windowBackgroundColor))
        .onAppear { _ = timerManager.getWeeklyData() }
    }
    
    // MARK: - View Sections
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Statistics")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Track your productivity journey")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            StatCard(
                title: "Today",
                value: "\(timerManager.todaySessionsCount)",
                subtitle: "sessions",
                icon: "flame.fill",
                color: accentColor,
                animationDelay: 0.1
            )
            
            StatCard(
                title: "This Week",
                value: "\(totalSessionsThisWeek)",
                subtitle: "sessions",
                icon: "calendar",
                color: accentColor,
                animationDelay: 0.2
            )
            
            StatCard(
                title: "Total Time",
                value: totalTimeString,
                subtitle: "focused",
                icon: "clock.fill",
                color: accentColor,
                animationDelay: 0.3
            )
        }
        .padding(.horizontal)
    }
    
    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)
            
            Chart(weeklyData.sorted(by: { $0.date < $1.date })) { stat in
                BarMark(
                    x: .value("Day", stat.dayOfWeek),
                    y: .value("Sessions", stat.sessions)
                )
                .foregroundStyle(accentColor.gradient)
                .cornerRadius(4)
            }
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.windowBackgroundColor))
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.headline)
            
            if !weeklyData.isEmpty {
                // Best day insight
                if let bestDay = weeklyData.max(by: { $0.sessions < $1.sessions }) {
                    InsightCard(
                        title: "Best Day",
                        description: "\(bestDay.dayOfWeek) with \(bestDay.sessions) sessions",
                        icon: "trophy.fill",
                        color: .yellow
                    )
                }
                
                // Daily average insight
                let averageSessions = weeklyData.isEmpty ? 0 : Double(totalSessionsThisWeek) / Double(weeklyData.count)
                InsightCard(
                    title: "Daily Average",
                    description: String(format: "%.1f sessions per day", averageSessions),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )
                
                // Current streak insight
                InsightCard(
                    title: "Current Streak",
                    description: "\(calculateCurrentStreak()) day\(calculateCurrentStreak() == 1 ? "" : "s") in a row",
                    icon: "bolt.fill",
                    color: .orange
                )
            } else {
                InsightCard(
                    title: "No Data Yet",
                    description: "Complete some focus sessions to see insights",
                    icon: "chart.bar.doc.horizontal",
                    color: .gray
                )
            }
        }
        .padding()
        .background(Color(.windowBackgroundColor))
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
    }
    
    // MARK: - Helper Methods
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = Date()
        
        // Sort dates in descending order
        let dates = weeklyData
            .compactMap { dateString -> Date? in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.date(from: dateString.date)
            }
            .sorted(by: >)
        
        var streak = 0
        var currentDate = today
        
        // Count consecutive days
        for date in dates {
            if calendar.isDate(date, inSameDayAs: currentDate) ||
               calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: currentDate)!) {
                streak += 1
                currentDate = date
            } else {
                break
            }
        }
        
        return streak
    }
}
