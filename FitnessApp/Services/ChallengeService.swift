//
//  ChallengeService.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 30/04/2023.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ChallengeServiceProtocol {
    func create(_ challenge: ChallengeModel) -> AnyPublisher<Void, CustomError>
    func observeChallenges(userId: UserId) -> AnyPublisher<[ChallengeModel], CustomError>
    func delete(_ challengeId: String) -> AnyPublisher<Void, CustomError>
    func updateChallenge(_ challengeId: String, activities: [Activity]) -> AnyPublisher<Void, CustomError>
}

final class ChallengeService: ChallengeServiceProtocol {
    private let db = Firestore.firestore()

    /// Metoda obsluguje zapisanie przeslanego jako argument obiektu wyzwania w bazie Firestore
    ///
    /// - Parameters:
    ///   - challenge: Obiekt wyzwania
    func create(_ challenge: ChallengeModel) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            do {
                _ = try self.db.collection("challenges").addDocument(from: challenge) { error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(.default()))
            }
        }.eraseToAnyPublisher()
    }

    /// Metoda obsluguje pobranie wyzwan zalogowanego uzytkownika z bazy Firestore,
    /// pobrane wyzwania sa posortowane malejaco po polu startDate
    ///
    /// - Parameters:
    ///   - userId: identyfikator / login uzytkownika
    func observeChallenges(userId: UserId) -> AnyPublisher<[ChallengeModel], CustomError> {
        let query = db.collection("challenges").whereField("userId", isEqualTo: userId).order(by: "startDate", descending: true)
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[ChallengeModel], CustomError> in
                do {
                    let challenges = try snapshot.documents.map {
                        try $0.data(as: ChallengeModel.self)
                    }
                    return Just(challenges)
                        .setFailureType(to: CustomError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Blad parsowania"))
                        .eraseToAnyPublisher()
                }

            }.eraseToAnyPublisher()
    }

    /// Metoda obsluguje usuniecie wybranego wyzwania z bazy Firestore
    ///
    /// - Parameters:
    ///   - challengeId: id wyzwania
    func delete(_ challengeId: String) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            self.db.collection("challenges").document(challengeId).delete { error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Metoda obsluguje zaktualizowanie wartosci pol w wybranym wyzwaniu bazie Firestore
    ///
    /// - Parameters:
    ///   - challengeId: id wyzwania
    ///   - activities: tablica aktywnosci podejmowanych w wyzwaniu
    func updateChallenge(_ challengeId: String, activities: [Activity]) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            self.db.collection("challenges").document(challengeId).updateData(
                [
                    "activities": activities.map {
                        ["date": $0.date, "isComplete": $0.isComplete]
                    },
                ]
            ) { error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
