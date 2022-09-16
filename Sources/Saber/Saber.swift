open class Saber {
    let text = "Hello, Saber!"
    init() {}
}

public extension Saber {
    /// Hello, Saber!
    func sayHello() {
        Log.info(text)
    }
}
