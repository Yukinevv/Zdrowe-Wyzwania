//
//  PrivacyPolicyView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/12/2023.
//

import SwiftUI

struct PrivacyPolicyView: View {
    let viewModel: PrivacyPolicyViewModel = PrivacyPolicyViewModel()

    var body: some View {
        VStack {
            ScrollView {
                Text(viewModel.privacyPolicyContent)
            }
            .padding()
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}

class PrivacyPolicyViewModel {
    let privacyPolicyContent = """
    Polityka Prywatności Aplikacji Zdrowe Wyzwania

    Data ostatniej aktualizacji: 29.12.2023

    # 1. Wprowadzenie

    Aplikacja "Zdrowe Wyzwania" szanuje prywatność użytkowników i zobowiązuje się do ochrony Twoich danych osobowych. Niniejsza Polityka Prywatności wyjaśnia, jak zbieram, używam, udostępniam i chronię Twoje dane, ze szczególnym uwzględnieniem danych zdrowotnych pobranych z bazy HealthKit.

    # 2. Dane, które Zbieram

    Zbieramy i przetwarzamy następujące kategorie danych:
    - Dane identyfikacyjne: takie jak imię, adres e-mail.
    - Dane zdrowotne: w tym dane o aktywności fizycznej, tętnie, spalonych kaloriach, jakości snu i innych wskaźnikach zdrowotnych pobieranych z HealthKit.

    # 3. Jak Używam Twoich Danych

    Twoje dane są wykorzystywane w celu:
    - Świadczenia usług aplikacji, w tym personalizacji treści.
    - Analizy i ulepszenia funkcji aplikacji.
    - Komunikacji z Tobą, np. poprzez informacje o postępach.

    # 4. Udostępnianie Danych

    Nie udostępniam Twoich danych zdrowotnych stronom trzecim bez Twojej wyraźnej zgody, chyba że jest to wymagane przez prawo.

    # 5. Ochrona Danych

    Stosuję środki bezpieczeństwa technicznego i organizacyjnego, aby zapewnić ochronę Twoich danych przed nieuprawnionym dostępem, zmianą, ujawnieniem lub zniszczeniem.

    # 6. Twoje Prawa

    Masz prawo do:
    - Dostępu do Twoich danych.
    - Sprostowania nieprawidłowych danych.
    - Usunięcia danych lub ograniczenia ich przetwarzania.
    - Wycofania zgody na przetwarzanie danych.

    # 7. Zmiany w Polityce Prywatności

    Mogę aktualizować niniejszą politykę. O wszelkich zmianach będziemy informować poprzez aplikację lub e-mail.

    # 8. Kontakt

    W przypadku pytań dotyczących tej polityki, proszę o kontakt pod adresem: adrianrodzic@mat.umk.pl.
    """
}
