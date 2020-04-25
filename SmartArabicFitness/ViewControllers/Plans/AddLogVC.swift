//
//  AddLogVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/9/13.
//  Copyright © 2018 raptor. All rights reserved.
//

import CoreStore
import JTAppleCalendar
import SwiftDate
import UIKit

class AddLogVC: UIViewController {
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearPanel: UIStackView!
    @IBOutlet weak var weekPanel: UIStackView!

    var plan: Plans!
    lazy var region: Region = {
        return Region(calendar: Calendars.gregorian, zone: TimeZone.current, locale: isEn ? Locales.english : Locales.arabic)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup calendar
        yearPanel.semanticContentAttribute = .forceLeftToRight
        weekPanel.semanticContentAttribute = .forceLeftToRight
        calendarView.semanticContentAttribute = .forceLeftToRight
        calendarView.visibleDates { dates in
            guard let date = dates.monthDates.first?.date else { return }
            self.dateLabel.text = DateInRegion(date, region: self.region).toFormat("MMMM yyyy")
        }
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarContainer.shadow(top: false, bottom: true)
    }

    @IBAction func onPrevMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }

    @IBAction func onNextMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }

    @IBAction func onSaveAction(_ sender: Any) {
        CoreStore.perform(asynchronous: { transaction in
            let log = transaction.create(Into<Logs>())
            log.issuedAt = self.calendarView.selectedDates.first
            log.planId = self.plan.id
            print("Add not at date : \(self.calendarView.selectedDates.first!)")
        }) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension AddLogVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    /*
     * 2018 01 01 to yyyy 12 31
     */
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = "2018 01 01".toDate()!
        let endDate = (DateInRegion(Date(), region: region) + 3.years).dateAtEndOf(.year)

        let params = ConfigurationParameters(startDate: startDate.date, endDate: endDate.date)
        return params
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        handleCell(cell: cell, cellForItemAt: date, cellState: cellState)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCell(cell: cell as! CalendarCell, cellForItemAt: date, cellState: cellState)
    }

    func handleCell(cell: CalendarCell, cellForItemAt date: Date, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.dateLabel.text = cellState.text
        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        cell.selectCell(selected: cellState.isSelected, isSunday: isSunday, isToday: isToday)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        (cell as? CalendarCell)?.selectCell(selected: true, isSunday: isSunday, isToday: isToday)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        (cell as? CalendarCell)?.selectCell(selected: false, isSunday: isSunday, isToday: isToday)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        dateLabel.text = DateInRegion(date, region: region).toFormat("MMMM yyyy")
    }
}
