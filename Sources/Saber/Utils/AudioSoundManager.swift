import AVFoundation
import AVKit
import UIKit

public enum AudioSoundManager {}
// MARK: - 播放声音
public extension AudioSoundManager {
    /// 播放音频文件(`音频文件名称`)
    /// - Parameters:
    ///   - audioName: 音频文件名称
    ///   - loops: 循环播放次数(`-1`为持续播放)
    /// - Returns: `AVAudioPlayer?`
    @discardableResult
    static func playAudio(with audioName: String?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioURL = Bundle.main.url(forResource: audioName, withExtension: nil) else {
            return nil
        }
        return playAudio(from: audioURL, loops: loops)
    }

    /// 播放音频文件(`音频文件URL`)
    /// - Parameters:
    ///   - audioURL: 音频文件`URL`
    ///   - loops: 循环播放次数(`-1`为持续播放)
    /// - Returns: `AVAudioPlayer?`
    @discardableResult
    static func playAudio(from audioURL: URL?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioURL else { return nil }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setCategory(.playback)

            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.prepareToPlay()
            player.numberOfLoops = loops
            player.play()

            return player
        } catch {
            sb1.debug(error.localizedDescription)
            return nil
        }
    }

    /// 播放指定`文件名称`的音效
    /// - Parameters:
    ///   - soundName: 音效文件名称
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    static func playSound(with soundName: String?, isShake: Bool = false, completion: Callbacks.Completion? = nil) {
        guard let soundName,
              let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil)
        else {
            return
        }
        playSound(from: soundURL, isShake: isShake, completion: completion)
    }

    /// 播放指定路径的音效
    /// - Parameters:
    ///   - soundPath: 音效文件路径
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    static func playSound(from soundURL: URL?, isShake: Bool = false, completion: Callbacks.Completion? = nil) {
        guard let soundURL else {
            return
        }
        let soundCFURL = soundURL as CFURL
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundCFURL, &soundID)
        playSound(with: soundID, isShake: isShake, completion: completion)
    }

    /// 播放指定`SoundID`
    /// - Parameters:
    ///   - soundID: 音效ID
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    static func playSound(with soundID: SystemSoundID, isShake: Bool = false, completion: Callbacks.Completion? = nil) {
        if isShake {
            AudioServicesPlayAlertSoundWithCompletion(soundID) {
                AudioServicesDisposeSystemSoundID(soundID)
                completion?()
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(soundID) {
                completion?()
            }
        }
    }
}

// MARK: - 震动级别
public extension AudioSoundManager {
    enum ShakeLevel {
        /// 标准长震动
        case standard
        /// 普通短震`3D Touch`中`Peek`震动反馈
        case normal
        /// 普通短震`3D Touch`中`Pop`震动反馈`home键`的振动
        case middle
        /// 连续三次短震
        case three
        /// 持续震动
        case always

        /// 系统音效ID
        var soundID: SystemSoundID {
            switch self {
            case .standard:
                return kSystemSoundID_Vibrate
            case .normal:
                return SystemSoundID(1519)
            case .middle:
                return SystemSoundID(1520)
            case .three:
                return SystemSoundID(1521)
            case .always:
                return kSystemSoundID_Vibrate
            }
        }
    }

    /// 震动
    /// - Parameters:
    ///   - level: 震动级别`类型`
    ///   - completion: 完成回调, 如果`level == .always`回调不执行
    static func shake(_ level: ShakeLevel, completion: Callbacks.Completion? = nil) {
        if level == .always { // 持续震动
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }, nil)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlaySystemSoundWithCompletion(level.soundID) {
                completion?()
            }
        }
    }

    /// 停止震动
    static func stopShake() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
