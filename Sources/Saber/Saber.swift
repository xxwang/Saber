import UIKit

public struct Saber {
    let text = "Hello, Saber!"
}

public extension Saber {
    /// `Hello, Saber!`
    static func sayHello() {
        sb1.info(Saber().text)
    }
}
