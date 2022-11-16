import HealthKit

// MARK: - 判断
public extension SaberExt where Base: HKActivitySummary {
    /// 检查是否达到设定的站立小时数
    var isStandGoalMet: Bool {
        return base.appleStandHoursGoal.compare(base.appleStandHours) != .orderedDescending
    }

    /// 检查是否达到设置的锻炼的分钟数
    var isExerciseTimeGoalMet: Bool {
        return base.appleExerciseTimeGoal.compare(base.appleExerciseTime) != .orderedDescending
    }

    /// 检查是否达到设置的活动能量
    var isEnergyBurnedGoalMet: Bool {
        return base.activeEnergyBurnedGoal.compare(base.activeEnergyBurned) != .orderedDescending
    }
}
