//
//  UserService.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 23/04/2023.
//

import Combine
import FirebaseAuth

protocol UserServiceProtocol {
    var currentUser: User? { get }
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, CustomError>
    func observeAuthChanges() -> AnyPublisher<User?, Never>
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, CustomError>
    func logout() -> AnyPublisher<Void, CustomError>
    func login(email: String, password: String) -> AnyPublisher<Void, CustomError>
    func signup(email: String, password: String) -> AnyPublisher<Void, CustomError>
}

final class UserService: UserServiceProtocol {
    let currentUser = Auth.auth().currentUser

    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }

    func signInAnonymously() -> AnyPublisher<User, CustomError> {
        return Future<User, CustomError> { promise in
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    return promise(.failure(.auth(description: error.localizedDescription)))
                } else if let user = result?.user {
                    return promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }

    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }

    func linkAccount(email: String, password: String) -> AnyPublisher<Void, CustomError> {
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        return Future<Void, CustomError> { promise in
            Auth.auth().currentUser?.link(with: emailCredential) { result, error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                } else if let user = result?.user {
                    Auth.auth().updateCurrentUser(user) { error in
                        if let error = error {
                            return promise(.failure(.default(description: error.localizedDescription)))
                        } else {
                            return promise(.success(()))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }

    func login(email: String, password: String) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func signup(email: String, password: String) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
