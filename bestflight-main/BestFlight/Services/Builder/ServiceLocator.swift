import Foundation

class ServiceLocator {

    // MARK: Properties

    static let shared: ServiceLocator = ServiceLocator()
    private lazy var services: [String: Any] = [:]

    // MARK: Instance methods

    func service<T>() -> T? {
        services[typeName(T.self)] as? T
    }

    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }

    // MARK: Class methods

    static func service<T>() -> T? {
        shared.service()
    }

    static func addService<T>(service: T) {
        shared.services[shared.typeName(T.self)] = service
    }

    static func removeService<T>(service: T) {
        shared.services[shared.typeName(T.self)] = nil
    }

}
