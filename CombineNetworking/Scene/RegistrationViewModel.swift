//
//  RegistrationViewModel.swift
//  CombineNetworking
//
//  Created by Essam Fahmi on 11/02/2024.
//

import Foundation
import Combine
import NetworkingKit

class RegistrationViewModel: ObservableObject {
    // MARK: - Private Properties
    
    private let onboardingService: OnboardingService
    private var cancellableSet: Set<AnyCancellable> = []

    // MARK: - Input Properties

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    
    // MARK: - Output Properties

    enum Status: Equatable {
        case success(username: String)
        case failure(message: String)
    }
    
    @Published var registrationResult: Status?

    // MARK: - Init

    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
    }

    // MARK: - Methods

    func register() {
        onboardingService.register(email: email, password: password, name: name)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.registrationResult = .failure(message: error.localizedDescription)
            } receiveValue: { [weak self] response in
                guard let username = response.data?.name else {
                    self?.registrationResult = .failure(message: "Not Found")
                    return
                }
                self?.registrationResult = .success(username: username)
                // TODO: - Manage state and handle response.data (RemoteRegisterUser)
                // Open next page
            }
            .store(in: &cancellableSet)
    }
}
