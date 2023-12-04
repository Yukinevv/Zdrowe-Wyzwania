//
//  Date+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Foundation

extension Date {
    static var dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }()

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static var dateWithoutYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }

    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let oneWeek = calendar.date(byAdding: .day, value: -6, to: Date())
        return calendar.startOfDay(for: oneWeek!)
    }

    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }

    static var threeMonthsAgo: Date {
        let calendar = Calendar.current
        let threeMonths = calendar.date(byAdding: .month, value: -3, to: Date())
        return calendar.startOfDay(for: threeMonths!)
    }

    static var yearToDate: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())

        return calendar.date(from: components)!
    }

    static var oneYearAgo: Date {
        let calendar = Calendar.current
        let oneYear = calendar.date(byAdding: .year, value: -1, to: Date())
        return calendar.startOfDay(for: oneYear!)
    }

    static var weekAgo: Date {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())
        return calendar.startOfDay(for: weekAgo!)
    }

    // Starts on Monday
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Monday

        return calendar.date(from: components)!
    }

//    func weekday() -> String {
//        let weekDays = ["Niedziela", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota"]
//        let myCalendar = Calendar(identifier: .gregorian)
//        let weekDay = myCalendar.component(.weekday, from: self)
//        return String(weekDays[weekDay - 1].prefix(3))
//    }

    func weekday() -> String {
        let weekDays = ["Nd", "Pon", "Wt", "Śr", "Czw", "Pt", "Sob"]
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return String(weekDays[weekDay - 1])
    }

    func day() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        return myCalendar.component(.day, from: self)
    }
}
