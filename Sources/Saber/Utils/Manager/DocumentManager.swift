import UIKit

// MARK: - DocumentManager
public class DocumentManager: NSObject {
    static let shared = DocumentManager()

    override private init() {
        super.init()
    }

    /// 文件回调
    var completion: ((_ isSuccess: Bool, _ data: Data?, _ fileName: String?) -> Void)?
}

// MARK: - 打开文件
public extension DocumentManager {
    /// 打开文件
    /// - `Capabilities` -> `iCloud` -> `iCould Documents`允许访问文件
    /// - `Containers` -> `+` -> `iCloud.bundleid` 允许下载icloud资源
    /// - Parameters:
    ///   - types:需要的文件类型
    ///   - mode:操作模式
    ///   - complete:完成回调(文件数据,文件名)
    func openDocument(_ types: [String], mode: UIDocumentPickerMode, complete: @escaping (_ isSuccess: Bool, _ data: Data?, _ fileName: String?) -> Void) {
        completion = complete
        //    常用格式
        //    "public.content",
        //    "public.text",
        //    "public.source-code",
        //    "public.image",
        //    "public.audiovisual-content",
        //    "com.adobe.pdf",
        //    "com.apple.keynote.key",
        //    "com.microsoft.word.doc",
        //    "com.microsoft.excel.xls",
        //    "com.microsoft.powerpoint.ppt",
        let documentVC = UIDocumentPickerViewController(documentTypes: types, in: mode)
        documentVC.delegate = self
        documentVC.modalPresentationStyle = .fullScreen
        UIWindow.topViewController?.presentVC(documentVC)
    }
}

// MARK: - UIDocumentPickerDelegate
extension DocumentManager: UIDocumentPickerDelegate {
    /// 文件选择回调
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let fileName = url.lastPathComponent

        if iCloudEnable {
            download(url) { fileData in
                self.completion?(true, fileData, fileName)
            }
        } else {
            if let parent = UIWindow.windowRootViewController {
                UIApplication.openSettings("请允许使用【iCloud】云盘", message: nil, cancel: "取消", confirm: "确认", parent: parent)
            }
        }
    }

    /// 用户关闭文件选择控制器回调
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion?(false, nil, nil)
    }
}

// MARK: - 下载文件
public extension DocumentManager {
    /// iCloud是否开启
    var iCloudEnable: Bool {
        let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        return (url != nil)
    }

    /// 下载文件
    func download(_ documentURL: URL, completion: ((Data) -> Void)? = nil) {
        let document = CMDocument(fileURL: documentURL)
        document.open { success in
            if success {
                document.close(completionHandler: nil)
            }
            if let callback = completion {
                callback(document.data)
            }
        }
    }
}

// MARK: - CMDocument
class CMDocument: UIDocument {
    public var data = Data()
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        data = contents as! Data
    }
}
