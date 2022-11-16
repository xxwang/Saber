public struct Exts {
    let text = "Hello, Saber!"
}

public extension Exts {
        /// Hello, Saber!
    static func sayHello() {
        Log.info(Exts().text)
    }
}
