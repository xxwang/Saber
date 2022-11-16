public struct Saber {
    let text = "Hello, Saber!"
}

public extension Saber {
    /// "Hello, Saber!"
    static func sayHello() {
        Debug.info(Saber().text)
    }
}
