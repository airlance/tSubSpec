import Foundation

class BaseNetworkService {

    // MARK: Properties

    let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

}
