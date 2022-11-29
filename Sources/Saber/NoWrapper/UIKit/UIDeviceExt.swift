import AdSupport
import AVKit
import CoreTelephony
import Security
import SystemConfiguration.CaptiveNetwork
import UIKit

// MARK: - 标识
public extension UIDevice {
    /// AppIDFV 获取失败则返回空字符串
    static var IDFV: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    /// AppIDFA 用户关闭,则返回空字符串
    static var IDFA: String {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return ""
    }

    /// UUID
    static var UUID: String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        let uuidString = (strRef! as String).replacingOccurrences(of: "_", with: "")
        return uuidString
    }
}

// MARK: - 常用判断
public extension UIDevice {
    /// 是否是`iPad`
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 是否是`iPhone`
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

// MARK: - 设备区分
public extension UIDevice {
    /// 当前设备是否越狱
    static var isBreak: Bool {
        if sb1.isSimulator {
            return false
        }
        let paths = ["/Applications/Cydia.app", "/private/var/lib/apt/",
                     "/private/var/lib/cydia", "/private/var/stash"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        let path = String(format: "/private/%@", UUID)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            NSLog(error.localizedDescription)
        }
        return false
    }

    /// 当前设备能否打电话
    /// - Returns:结果
    static func isCanCallTel() -> Bool {
        if let url = URL(string: "tel://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

// MARK: - 设备控制
public extension UIDevice {
    /// 闪光灯是否打开
    static var flashIsOn: Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            sb1.info("camera invalid, please check")
            return false
        }
        return device.torchMode == .on ? true : false
    }

    /// 是否打开闪光灯
    /// - Parameter on:是否打开
    static func flash(on: Bool) {
        // 获取摄像设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            sb1.info("camera invalid, please check")
            return
        }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on, device.torchMode == .off {
                    device.torchMode = .on
                }
                if !on, device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                sb1.info(error.localizedDescription)
            }
        }
    }
}

// MARK: - 有关设备运营商的信息
public extension UIDevice {
    /// sim卡信息
    static func simCardInfos() -> [CTCarrier]? {
        return getCarriers()
    }

    /// 数据业务对应的通信技术
    /// - Returns:通信技术
    static func currentRadioAccessTechnologys() -> [String]? {
        guard !sb1.isSimulator else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let currentRadioTechs = info.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            return currentRadioTechs.allValues()
        } else {
            guard let currentRadioTech = info.currentRadioAccessTechnology else {
                return nil
            }
            return [currentRadioTech]
        }
    }

    /// 设备网络制式
    /// - Returns:网络
    static func networkTypes() -> [String]? {
        // 获取并输出运营商信息
        guard let currentRadioTechs = currentRadioAccessTechnologys() else {
            return nil
        }
        return currentRadioTechs.compactMap { getNetworkType(currentRadioTech: $0) }
    }

    /// 运营商名字
    /// - Returns:运营商名字
    static func carrierNames() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.carrierName! }
    }

    /// 移动国家码(MCC)
    /// - Returns:移动国家码(MCC)
    static func mobileCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileCountryCode! }
    }

    /// 移动网络码(MNC)
    /// - Returns:移动网络码(MNC)
    static func mobileNetworkCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileNetworkCode! }
    }

    /// ISO国家代码
    /// - Returns:ISO国家代码
    static func isoCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.isoCountryCode! }
    }

    /// 是否允许VoIP
    /// - Returns:是否允许VoIP
    static func isAllowsVOIPs() -> [Bool]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.allowsVOIP }
    }

    /// 获取并输出运营商信息
    /// - Returns:运营商信息
    private static func getCarriers() -> [CTCarrier]? {
        guard !sb1.isSimulator else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return []
            }
            return providers.filter { $0.value.carrierName != nil }.allValues()
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return []
            }
            return [carrier]
        }
    }

    /// 根据数据业务信息获取对应的网络类型
    /// - Parameter currentRadioTech:当前的无线电接入技术信息
    /// - Returns:网络类型
    private static func getNetworkType(currentRadioTech: String) -> String {
        /// 手机的数据业务对应的通信技术
        /// CTRadioAccessTechnologyGPRS:2G(有时又叫2.5G,介于2G和3G之间的过度技术)
        /// CTRadioAccessTechnologyEdge:2G (有时又叫2.75G,是GPRS到第三代移动通信的过渡)
        /// CTRadioAccessTechnologyWCDMA:3G
        /// CTRadioAccessTechnologyHSDPA:3G (有时又叫 3.5G)
        /// CTRadioAccessTechnologyHSUPA:3G (有时又叫 3.75G)
        /// CTRadioAccessTechnologyCDMA1x :2G
        /// CTRadioAccessTechnologyCDMAEVDORev0:3G
        /// CTRadioAccessTechnologyCDMAEVDORevA:3G
        /// CTRadioAccessTechnologyCDMAEVDORevB:3G
        /// CTRadioAccessTechnologyeHRPD:3G (有时又叫 3.75G,是电信使用的一种3G到4G的演进技术)
        /// CTRadioAccessTechnologyLTE:4G (或者说接近4G)
        /// // 5G:NR是New Radio的缩写,新无线(5G)的意思,NRNSA表示5G NR的非独立组网(NSA)模式.
        /// CTRadioAccessTechnologyNRNSA:5G NSA
        /// CTRadioAccessTechnologyNR:5G
        if #available(iOS 14.1, *), currentRadioTech == CTRadioAccessTechnologyNRNSA || currentRadioTech == CTRadioAccessTechnologyNR {
            return "5G"
        }

        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyCDMA1x,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS:
            networkType = "2G"
        case CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyWCDMA:
            networkType = "3G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        default:
            break
        }
        return networkType
    }

    /// 获取运营商
    static var deviceSupplier: String {
        let info = CTTelephonyNetworkInfo()
        var supplier = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.isEmpty {
                    return "无手机卡"
                } else { // 获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else {
                            return "无手机卡"
                        }
                        // 查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else {
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else {
                    return "无手机卡"
                }
                return carrier.carrierName!
            } else {
                return "无手机卡"
            }
        }
    }
}

// MARK: - 存储信息
public extension UIDevice {
    /// 当前硬盘的空间
    static var diskSpace: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 当前硬盘可用空间
    static var diskSpaceFree: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 可用磁盘空间(字节)
    static var freeDiskSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    /// 当前硬盘已经使用的空间
    static var diskSpaceUsed: Int64 {
        let total = diskSpace
        let free = diskSpaceFree
        guard total > 0, free > 0 else {
            return -1
        }
        let used = total - free
        guard used > 0 else {
            return -1
        }

        return used
    }

    /// 获取总内存大小
    static var memoryTotal: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
}

// MARK: - 设备的基本信息
public extension UIDevice {
    /// 当前设备的系统版本
    static var currentSystemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// 当前系统更新时间
    static var systemUpdateTime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }

    /// 当前设备的类型
    static var deviceModel: String {
        return UIDevice.current.model
    }

    /// 当前系统的名称
    static var currentSystemName: String {
        return UIDevice.current.systemName
    }

    /// 当前设备的名称
    static var currentDeviceName: String {
        return UIDevice.current.name
    }

    /// 当前设备语言
    static var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// 设备区域化型号
    static var currentLocalizedModel: String {
        return UIDevice.current.localizedModel
    }

    /// 获取CPU核心数量
    static var deviceCPUCount: Int {
        var ncpu = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }

    /// 获取CPU类型
    static var deviceCPUType: String? {
        let HOST_BASIC_INFO_COUNT = MemoryLayout<host_basic_info>.stride / MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_BASIC_INFO_COUNT)
        var hostInfo = host_basic_info()
        _ = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_info(mach_host_self(), Int32(HOST_BASIC_INFO), $0, &size)
            }
        }
        switch hostInfo.cpu_type {
        case CPU_TYPE_ARM:
            return "CPU_TYPE_ARM"
        case CPU_TYPE_ARM64:
            return "CPU_TYPE_ARM64"
        case CPU_TYPE_ARM64_32:
            return"CPU_TYPE_ARM64_32"
        case CPU_TYPE_X86:
            return "CPU_TYPE_X86"
        case CPU_TYPE_X86_64:
            return"CPU_TYPE_X86_64"
        case CPU_TYPE_ANY:
            return"CPU_TYPE_ANY"
        case CPU_TYPE_VAX:
            return"CPU_TYPE_VAX"
        case CPU_TYPE_MC680x0:
            return"CPU_TYPE_MC680x0"
        case CPU_TYPE_I386:
            return"CPU_TYPE_I386"
        case CPU_TYPE_MC98000:
            return"CPU_TYPE_MC98000"
        case CPU_TYPE_HPPA:
            return"CPU_TYPE_HPPA"
        case CPU_TYPE_MC88000:
            return"CPU_TYPE_MC88000"
        case CPU_TYPE_SPARC:
            return"CPU_TYPE_SPARC"
        case CPU_TYPE_I860:
            return"CPU_TYPE_I860"
        case CPU_TYPE_POWERPC:
            return"CPU_TYPE_POWERPC"
        case CPU_TYPE_POWERPC64:
            return"CPU_TYPE_POWERPC64"
        default:
            return nil
        }
    }

    /// 获取当前设备IP
    static var ipAddress: String? {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        if let ipStr = addresses.first {
            return ipStr
        } else {
            return nil
        }
    }

    /// 获取连接wifi的ip地址, 需要定位权限和添加Access WiFi information
    static var wifiIP: String? {
        var address: String?
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0,
              let firstAddr = ifaddr
        else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }

    /// 获取连接wifi的名字和mac地址, 需要定位权限和添加Access WiFi information
    static var WifiNameWithMac: (wifiName: String?, macIP: String?) {
        guard let interfaces: NSArray = CNCopySupportedInterfaces() else {
            return (nil, nil)
        }
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid, mac)
    }

    /// 设备的名字
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return getDeviceName(by: identifier)
    }

    /// 根据标识获取对应设备名称
    /// - Parameter identifier:标识
    /// - Returns:设备名称
    static func getDeviceName(by identifier: String) -> String {
        #if os(iOS)
            switch identifier {
            case "iPod5,1": return "iPod Touch 5"
            case "iPod7,1": return "iPod Touch 6"
            case "iPhone3,1",
                 "iPhone3,2",
                 "iPhone3,3": return "iPhone 4"
            case "iPhone4,1": return "iPhone 4s"
            case "iPhone5,1",
                 "iPhone5,2": return "iPhone 5"
            case "iPhone5,3",
                 "iPhone5,4": return "iPhone 5c"
            case "iPhone6,1",
                 "iPhone6,2": return "iPhone 5s"
            case "iPhone7,2": return "iPhone 6"
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone8,1": return "iPhone 6s"
            case "iPhone8,2": return "iPhone 6s Plus"
            case "iPhone9,1",
                 "iPhone9,3": return "iPhone 7"
            case "iPhone9,2",
                 "iPhone9,4": return "iPhone 7 Plus"
            case "iPhone8,4": return "iPhone SE"
            case "iPhone10,1",
                 "iPhone10,4": return "iPhone 8"
            case "iPhone10,2",
                 "iPhone10,5": return "iPhone 8 Plus"
            case "iPhone10,3",
                 "iPhone10,6": return "iPhone X"
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4",
                 "iPhone11,6": return "iPhone XS Max"
            case "iPhone11,8": return "iPhone XR"
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"
            case "iPad2,1",
                 "iPad2,2",
                 "iPad2,3",
                 "iPad2,4": return "iPad 2"
            case "iPad3,1",
                 "iPad3,2",
                 "iPad3,3": return "iPad 3"
            case "iPad3,4",
                 "iPad3,5",
                 "iPad3,6": return "iPad 4"
            case "iPad4,1",
                 "iPad4,2",
                 "iPad4,3": return "iPad Air"
            case "iPad5,3",
                 "iPad5,4": return "iPad Air 2"
            case "iPad6,11",
                 "iPad6,12": return "iPad 5"
            case "iPad7,5",
                 "iPad7,6": return "iPad 6"
            case "iPad2,5",
                 "iPad2,6",
                 "iPad2,7": return "iPad Mini"
            case "iPad4,4",
                 "iPad4,5",
                 "iPad4,6": return "iPad Mini 2"
            case "iPad4,7",
                 "iPad4,8",
                 "iPad4,9": return "iPad Mini 3"
            case "iPad5,1",
                 "iPad5,2": return "iPad Mini 4"
            case "iPad6,3",
                 "iPad6,4": return "iPad Pro (9.7-inch)"
            case "iPad6,7",
                 "iPad6,8": return "iPad Pro (12.9-inch)"
            case "iPad7,1",
                 "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3",
                 "iPad7,4": return "iPad Pro (10.5-inch)"
            case "iPad8,1",
                 "iPad8,2",
                 "iPad8,3",
                 "iPad8,4": return "iPad Pro (11-inch)"
            case "iPad8,5",
                 "iPad8,6",
                 "iPad8,7",
                 "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3": return "Apple TV"
            case "AppleTV6,2": return "Apple TV 4K"
            case "AudioAccessory1,1": return "HomePod"
            case "i386",
                 "x86_64": return "Simulator \(getDeviceName(by: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default: return identifier
            }
        #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386",
                 "x86_64": return "Simulator \(getDeviceName(by: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
        #endif
    }
}
