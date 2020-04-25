//
//  LogVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/23.
//  Copyright © 2018 raptor. All rights reserved.
//

import CoreStore
import JTAppleCalendar
import SwiftDate
import UIKit

class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dotView: UIView!

    func selectCell(selected: Bool, isSunday: Bool, isToday: Bool, hasLog: Bool = false) {
        dotView.isHidden = !hasLog
        if selected {
            dateLabel.backgroundColor = .orange
            dateLabel.textColor = .white
            dotView.backgroundColor = .white
        } else {
            dateLabel.backgroundColor = isToday ? .groupTableViewBackground : .white
            dateLabel.textColor = isSunday ? .orange : .black
            dotView.backgroundColor = .orange
        }
    }
}

class LogsVC: UIViewController {
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearPanel: UIStackView!
    @IBOutlet weak var weekPanel: UIStackView!

    var plans: [Plans] = []
    var allPlans: [Plans] = []
    var existingDates: [Date] = []

    lazy var region: Region = {
        Region(calendar: Calendars.gregorian, zone: TimeZone.current, locale: isEn ? Locales.english : Locales.arabic)
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let logs = try? CoreStore.fetchAll(From<Logs>())
        existingDates = logs?.compactMap { $0.issuedAt } ?? []

        let plans = try? CoreStore.fetchAll(From<Plans>().orderBy(.ascending(\.id)))
        allPlans = plans ?? []

        calendarView.reloadData()
        calendarContainer.shadow(top: false, bottom: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeMenu()
        setupAds()

        yearPanel.semanticContentAttribute = .forceLeftToRight
        weekPanel.semanticContentAttribute = .forceLeftToRight
        setupCalendar()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let spliteVC = splitViewController else { return }
        hasMenu = spliteVC.displayMode == .allVisible
    }

    fileprivate func loadLogs(for date: Date) {
        let logDate = existingDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }.first
        if let logDate = logDate {
            let data = try? CoreStore.fetchAll(From<Logs>().where(\.issuedAt == logDate))
            let planIds = data?.map { $0.planId } ?? []
            plans = allPlans.filter { planIds.contains($0.id) }
        } else {
            plans = []
        }
        tableView.reloadData()
    }

    fileprivate func setupCalendar() {
        calendarView.semanticContentAttribute = .forceLeftToRight
        calendarView.ibCalendarDataSource = self
        calendarView.ibCalendarDelegate = self
        calendarView.visibleDates { dates in
            guard let date = dates.monthDates.first?.date else { return }
            self.dateLabel.text = DateInRegion(date, region: self.region).toFormat("MMMM yyyy")
        }
        calendarView.scrollToDate(Date(), animateScroll: false)
    }

    @IBAction func onPrevMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }

    @IBAction func onNextMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
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

extension LogsVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    /*
     * 2018 01 01 to yyyy 12 31
     */ func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = "2018 01 01".toDate()!
        let endDate = (DateInRegion(Date(), region: region) + 3.years).dateAtEndOf(.year)

        let params = ConfigurationParameters(startDate: startDate.date, endDate: endDate.date)
        return params
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell

        cell.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.dateLabel.text = cellState.text
        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        let filtered = existingDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }
        let hasLog = !filtered.isEmpty
        cell.selectCell(selected: cellState.isSelected, isSunday: isSunday, isToday: isToday, hasLog: hasLog)

        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }

        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        let filtered = existingDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }
        let hasLog = !filtered.isEmpty
        cell.selectCell(selected: cellState.isSelected, isSunday: isSunday, isToday: isToday, hasLog: hasLog)

        print("Did select date: \(cellState.date)")
        loadLogs(for: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }

        let isSunday = Calendar.current.dateComponents([.weekday], from: date).weekday == 1
        let isToday = Calendar.current.isDateInToday(date)
        let filtered = existingDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }
        let hasLog = !filtered.isEmpty
        cell.selectCell(selected: cellState.isSelected, isSunday: isSunday, isToday: isToday, hasLog: hasLog)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        dateLabel.text = DateInRegion(date, region: region).toFormat("MMMM yyyy")
    }
}

extension LogsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = plans[indexPath.row].name?.localized
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let plan = plans[indexPath.row]
        switch plan.id {
        case 3:
            let vc = AppStoryboard.Plan.instance.instantiateViewController(withIdentifier: "FullBodyPlan")
            navigationController?.pushViewController(vc, animated: true)
        case 4...7:
            let vc = AppStoryboard.Plan.viewController(viewControllerClass: SplitPlanVC.self)
            vc.plan = plan
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = AppStoryboard.Plan.viewController(viewControllerClass: PlanExercicesVC.self)
            vc.plan = plan
            vc.viewOnly = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
