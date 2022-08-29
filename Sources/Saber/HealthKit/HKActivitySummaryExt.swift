import HealthKit

public extension HKActivitySummary {
        /// 检查是否达到设定的站立小时数
    var isStandGoalMet: Bool {
        return appleStandHoursGoal.compare(appleStandHours) != .orderedDescending
    }
    
        /// 检查是否达到设置的锻炼的分钟数
    var isExerciseTimeGoalMet: Bool {
        return appleExerciseTimeGoal.compare(appleExerciseTime) != .orderedDescending
    }
    
        /// 检查是否达到设置的活动能量
    var isEnergyBurnedGoalMet: Bool {
        return activeEnergyBurnedGoal.compare(activeEnergyBurned) != .orderedDescending
    }
}
