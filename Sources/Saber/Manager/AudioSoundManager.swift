import AVFoundation
import AVKit
import UIKit

// MARK: - 震动级别枚举
public enum ShakeLevel {
    /// 标准长震动
    case standard
    /// 短振动,普通短震,3D Touch 中 Peek 震动反馈
    case normal
    /// 普通短震,3D Touch 中 Pop 震动反馈,home 键的振动
    case middle
    /// 连续三次短震
    case three

    static func systemSoundID(_ level: ShakeLevel) -> SystemSoundID {
        switch level {
        case .standard:
            return kSystemSoundID_Vibrate
        case .normal:
            return SystemSoundID(1519)
        case .middle:
            return SystemSoundID(1520)
        case .three:
            return SystemSoundID(1521)
        }
    }
}

public class AudioSoundManager {}

// MARK: - 播放音效
public extension AudioSoundManager {
    /// 播放音频文件,
    /// - Parameters:
    ///   - sound: 音频路径
    ///   - loops: 循环次数(若loops为负数(-1)需要手动停止)
    /// - Returns: AVAudioPlayer
    @discardableResult
    static func playAudio(_ sound: String, loops: Int = 0) -> AVAudioPlayer? {
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil) else {
            print("\(#file) -- [\(#line)]: \(sound) is invalid")
            return nil
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setCategory(.playback)

            let soundURL = URL(fileURLWithPath: soundPath)
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.prepareToPlay()
            player.numberOfLoops = loops
            player.play()
            return player
        } catch {
            print(error)
            return nil
        }
    }

    /// 播放短音效 30s内
    /// - Parameters:
    ///   - sound: 声源文件
    ///   - vibrate: 是否震动播放
    static func playAudioSound(_ sound: String, vibrate: Bool = false) {
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil) else {
            return
        }
        let soundURL = URL(fileURLWithPath: soundPath) as CFURL
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        if vibrate {
            AudioServicesPlayAlertSound(soundID)
        } else {
            AudioServicesPlaySystemSound(soundID)
        }
    }
}

// MARK: - 震动
public extension AudioSoundManager {
    /// 设置震动级别
    static func shakeLevel(_ level: ShakeLevel) {
        AudioServicesPlaySystemSound(ShakeLevel.systemSoundID(level))
    }

    /// 持续震动
    static func alwaysShake(_ play: Bool = true) {
        if !play {
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
            return
        }

        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }, nil)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    /// 停止震动
    static func stopShake() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
