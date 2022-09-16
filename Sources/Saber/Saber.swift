public struct Saber {
    var text = "Hello, Saber!"
    init() {}
}

public extension Saber {
    func sayHello() {
        Log.info(text)
    }
}
