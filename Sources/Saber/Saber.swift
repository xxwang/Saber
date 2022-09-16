public class Saber {
    let text = "Hello, Saber!"
    public init() {}
}

public extension Saber {
    /// Hello, Saber!
    func sayHello() {
        Log.info(text)
    }
}
