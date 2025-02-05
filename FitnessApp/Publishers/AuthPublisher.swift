//
//  AuthPublisher.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 02/05/2023.
//

import Combine
import FirebaseAuth

extension Publishers {
    struct AuthPublisher: Publisher {
        typealias Output = User?
        typealias Failure = Never

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let authSubscription = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubscription)
        }
    }

    class AuthSubscription<S: Subscriber>: Subscription where S.Input == User?, S.Failure == Never {
        private var subscriber: S?
        private var handler: AuthStateDidChangeListenerHandle?

        init(subscriber: S) {
            self.subscriber = subscriber

            // Nasluchiwanie zmiany stanu autentykacji
            handler = Auth.auth().addStateDidChangeListener { _, user in
                _ = subscriber.receive(user)
            }
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
            handler = nil
        }
    }
}
