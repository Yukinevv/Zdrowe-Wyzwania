//
//  HKWorkoutActivityType+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Foundation
import HealthKit

extension HKWorkoutActivityType {
    /* Mapowanie dostepnych typow treningu na czytelne nazwy */
    var name: String {
        switch self {
        case .americanFootball:             return "Football Amerykański"
        case .archery:                      return "Łucznictwo"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Koszykówka"
        case .bowling:                      return "Kręgle"
        case .boxing:                       return "Boks"
        case .climbing:                     return "Wspinaczka"
        case .crossTraining:                return "Trening Krzyżowy"
        case .curling:                      return "Curling"
        case .cycling:                      return "Kolarstwo"
        case .dance:                        return "Taniec"
        case .danceInspiredTraining:        return "Trening Inpirowany Tańcem"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Szermierka"
        case .fishing:                      return "Rybactwo"
        case .functionalStrengthTraining:   return "Funkcjonalny Trening Siłowy"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gimnastyka"
        case .handball:                     return "Piłka Ręczna"
        case .hiking:                       return "Turystyka Piesza"
        case .hockey:                       return "Hokej"
        case .hunting:                      return "Łowiectwo" // Polowanie
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Sztuki Walki"
        case .mindAndBody:                  return "Trening Umysłu i Ciała"
        case .mixedMetabolicCardioTraining: return "Trening Kardio pod Metabolizm"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Przygotowanie i Regeneracja"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Bieganie"
        case .sailing:                      return "Żeglarstwo"
        case .skatingSports:                return "Sporty Wodne"
        case .snowSports:                   return "Sporty Zimowe"
        case .soccer:                       return "Piłka nożna"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Schody"
        case .surfingSports:                return "Surfing"
        case .swimming:                     return "Pływanie"
        case .tableTennis:                  return "Tenis Stołowy"
        case .tennis:                       return "Tenis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Tradycyjny Trening Siłowy"
        case .volleyball:                   return "Siatkówka"
        case .walking:                      return "Spacer"
        case .waterFitness:                 return "Fitness w Wodzie"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Sporty Wodne"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"

        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Biegi Narciarskie"
        case .downhillSkiing:               return "Narciarstwo Zjazdowe"
        case .flexibility:                  return "Rozciąganie"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Skakanka"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Tempo Chodu na Wózku" // Inwalidzkim
        case .wheelchairRunPace:            return "Tempo Biegu na Wózku" // Inwalidzkim

        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Miks Cardio"
        case .handCycling:                  return "Hand Cycling"

        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"

        default:                            return "Inne"
        }
    }

    var commonName: String {
        switch self {
        case .highIntensityIntervalTraining: return "HIIT"
        default: return name
        }
    }

    /* Mapowanie dostepnych typow aktywnosci na pasujace emotikony */
    var associatedEmoji: String? {
        switch self {
        case .americanFootball:             return "🏈"
        case .archery:                      return "🏹"
        case .badminton:                    return "🏸"
        case .baseball:                     return "⚾️"
        case .basketball:                   return "🏀"
        case .bowling:                      return "🎳"
        case .boxing:                       return "🥊"
        case .curling:                      return "🥌"
        case .cycling:                      return "🚲"
        case .equestrianSports:             return "🏇"
        case .fencing:                      return "🤺"
        case .fishing:                      return "🎣"
        case .functionalStrengthTraining:   return "💪"
        case .golf:                         return "⛳️"
        case .hiking:                       return "🥾"
        case .hockey:                       return "🏒"
        case .lacrosse:                     return "🥍"
        case .martialArts:                  return "🥋"
        case .mixedMetabolicCardioTraining: return "❤️"
        case .paddleSports:                 return "🛶"
        case .rowing:                       return "🛶"
        case .rugby:                        return "🏉"
        case .sailing:                      return "⛵️"
        case .skatingSports:                return "⛸"
        case .snowSports:                   return "🛷"
        case .soccer:                       return "⚽️"
        case .softball:                     return "🥎"
        case .tableTennis:                  return "🏓"
        case .tennis:                       return "🎾"
        case .traditionalStrengthTraining:  return "🏋️‍♂️"
        case .volleyball:                   return "🏐"
        case .waterFitness, .waterSports:   return "💧"

        case .barre:                        return "🥿"
        case .crossCountrySkiing:           return "⛷"
        case .downhillSkiing:               return "⛷"
        case .kickboxing:                   return "🥋"
        case .snowboarding:                 return "🏂"

        case .mixedCardio:                  return "❤️"

        case .discSports:                   return "🥏"
        case .fitnessGaming:                return "🎮"

        default:                            return nil
        }
    }

    var associatedImageName: String {
        switch self {
        case .running:                          return "running"
        case .walking:                          return "walking"
        case .cycling:                          return "cycling"
        case .functionalStrengthTraining:       return "strength"
        case .traditionalStrengthTraining:      return "strength"
        case .highIntensityIntervalTraining:    return "hiit"

        default:                                return "other"
        }
    }
}
