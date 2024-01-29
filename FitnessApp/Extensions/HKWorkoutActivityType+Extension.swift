//
//  HKWorkoutActivityType+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Foundation
import HealthKit

extension HKWorkoutActivityType {
    // Mapowanie dostepnych typow treningu na czytelne nazwy
    var name: String {
        switch self {
        case .americanFootball:                 return "Football Amerykański"
        case .archery:                          return "Łucznictwo"
        case .badminton:                        return "Badminton"
        case .baseball:                         return "Baseball"
        case .basketball:                       return "Koszykówka"
        case .bowling:                          return "Kręgle"
        case .boxing:                           return "Boks"
        case .climbing:                         return "Wspinaczka"
        case .crossTraining:                    return "Trening Krzyżowy"
        case .curling:                          return "Curling"
        case .cycling:                          return "Kolarstwo"
        case .dance:                            return "Taniec"
        case .danceInspiredTraining:            return "Trening Inpirowany Tańcem"
        case .elliptical:                       return "Elliptical"
        case .equestrianSports:                 return "Equestrian Sports"
        case .fencing:                          return "Szermierka"
        case .fishing:                          return "Rybactwo"
        case .functionalStrengthTraining:       return "Funkcjonalny Trening Siłowy"
        case .golf:                             return "Golf"
        case .gymnastics:                       return "Gimnastyka"
        case .handball:                         return "Piłka Ręczna"
        case .hiking:                           return "Turystyka Piesza"
        case .hockey:                           return "Hokej"
        case .hunting:                          return "Łowiectwo" // Polowanie
        case .lacrosse:                         return "Lacrosse"
        case .martialArts:                      return "Sztuki Walki"
        case .mindAndBody:                      return "Trening Umysłu i Ciała"
        case .mixedMetabolicCardioTraining:     return "Trening Kardio pod Metabolizm"
        case .paddleSports:                     return "Paddle Sports"
        case .play:                             return "Play"
        case .preparationAndRecovery:           return "Przygotowanie i Regeneracja"
        case .racquetball:                      return "Racquetball"
        case .rowing:                           return "Rowing"
        case .rugby:                            return "Rugby"
        case .running:                          return "Bieganie"
        case .sailing:                          return "Żeglarstwo"
        case .skatingSports:                    return "Sporty Wodne"
        case .snowSports:                       return "Sporty Zimowe"
        case .soccer:                           return "Piłka nożna"
        case .softball:                         return "Softball"
        case .squash:                           return "Squash"
        case .stairClimbing:                    return "Schody"
        case .surfingSports:                    return "Surfing"
        case .swimming:                         return "Pływanie"
        case .tableTennis:                      return "Tenis Stołowy"
        case .tennis:                           return "Tenis"
        case .trackAndField:                    return "Track and Field"
        case .traditionalStrengthTraining:      return "Tradycyjny Trening Siłowy"
        case .volleyball:                       return "Siatkówka"
        case .walking:                          return "Spacer"
        case .waterFitness:                     return "Fitness w Wodzie"
        case .waterPolo:                        return "Water Polo"
        case .waterSports:                      return "Sporty Wodne"
        case .wrestling:                        return "Wrestling"
        case .yoga:                             return "Yoga"

        case .barre:                            return "Barre"
        case .coreTraining:                     return "Core Training"
        case .crossCountrySkiing:               return "Biegi Narciarskie"
        case .downhillSkiing:                   return "Narciarstwo Zjazdowe"
        case .flexibility:                      return "Rozciąganie"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                         return "Skakanka"
        case .kickboxing:                       return "Kickboxing"
        case .pilates:                          return "Pilates"
        case .snowboarding:                     return "Snowboarding"
        case .stairs:                           return "Stairs"
        case .stepTraining:                     return "Step Training"
        case .wheelchairWalkPace:               return "Tempo Chodu na Wózku" // Inwalidzkim
        case .wheelchairRunPace:                return "Tempo Biegu na Wózku" // Inwalidzkim

        case .taiChi:                           return "Tai Chi"
        case .mixedCardio:                      return "Miks Cardio"
        case .handCycling:                      return "Hand Cycling"

        case .discSports:                       return "Disc Sports"
        case .fitnessGaming:                    return "Fitness Gaming"

        default:                                return "Inne"
        }
    }

    // Mapowanie dostepnych typow treningu na skrocone nazwy
    var commonName: String {
        switch self {
        case .highIntensityIntervalTraining:    return "HIIT"
        default:                                return name
        }
    }

    // Mapowanie dostepnych typow aktywnosci na pasujace nazwy obrazkow
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

    // Mapowanie dostepnych typow aktywnosci na pasujace nazwy ikon
    var associatedImageSystemName: String {
        switch self {
        case .americanFootball:                 return "figure.american.football"
        case .archery:                          return "figure.archery"
        case .badminton:                        return "figure.badminton"
        case .baseball:                         return "figure.baseball"
        case .basketball:                       return "figure.basketball"
        case .bowling:                          return "figure.bowling"
        case .boxing:                           return "figure.boxing"
        case .climbing:                         return "figure.climbing"
        case .crossTraining:                    return "figure.cross.training"
        case .curling:                          return "figure.curling"
        case .cycling:                          return "figure.outdoor.cycle"
        case .dance:                            return "figure.dance"
        case .danceInspiredTraining:            return "figure.socialdance"
        case .elliptical:                       return "figure.elliptical"
        case .equestrianSports:                 return "figure.equestrian.sports"
        case .fencing:                          return "figure.fencing"
        case .fishing:                          return "figure.fishing"
        case .functionalStrengthTraining:       return "figure.strengthtraining.functional"
        case .golf:                             return "figure.golf"
        case .gymnastics:                       return "figure.gymnastics"
        case .handball:                         return "figure.handball"
        case .hiking:                           return "figure.hiking"
        case .hockey:                           return "figure.hockey"
        case .hunting:                          return "figure.hunting"
        case .lacrosse:                         return "figure.lacrosse"
        case .martialArts:                      return "figure.martial.arts"
        case .mindAndBody:                      return "figure.mind.and.body"
        case .mixedMetabolicCardioTraining:     return "figure.mixed.cardio"
        case .paddleSports:                     return "oar.2.crossed"
        case .play:                             return "figure.play"
        case .preparationAndRecovery:           return "plus.square.dashed"
        case .racquetball:                      return "figure.racquetball"
        case .rowing:                           return "figure.curling"
        case .rugby:                            return "figure.rugby"
        case .running:                          return "figure.run"
        case .sailing:                          return "figure.sailing"
        case .skatingSports:                    return "figure.skating"
        case .snowSports:                       return "figure.snowboarding"
        case .soccer:                           return "figure.soccer"
        case .softball:                         return "figure.softball"
        case .squash:                           return "figure.squash"
        case .stairClimbing:                    return "figure.stairs"
        case .surfingSports:                    return "figure.surfing"
        case .swimming:                         return "figure.pool.swim"
        case .tableTennis:                      return "figure.table.tennis"
        case .tennis:                           return "figure.tennis"
        case .trackAndField:                    return "figure.track.and.field"
        case .traditionalStrengthTraining:      return "figure.strengthtraining.traditional"
        case .volleyball:                       return "figure.volleyball"
        case .walking:                          return "figure.walk"
        case .waterFitness:                     return "figure.water.fitness"
        case .waterPolo:                        return "figure.waterpolo"
        case .waterSports:                      return "figure.water.fitness"
        case .wrestling:                        return "figure.wrestling"
        case .yoga:                             return "figure.yoga"

        case .barre:                            return "figure.barre"
        case .coreTraining:                     return "figure.core.training"
        case .crossCountrySkiing:               return "figure.skiing.crosscountry"
        case .downhillSkiing:                   return "figure.skiing.downhill"
        case .flexibility:                      return "figure.flexibility"
        case .highIntensityIntervalTraining:    return "figure.highintensity.intervaltraining"
        case .jumpRope:                         return "figure.jumprope"
        case .kickboxing:                       return "figure.kickboxing"
        case .pilates:                          return "figure.pilates"
        case .snowboarding:                     return "figure.snowboarding"
        case .stairs:                           return "figure.stairs"
        case .stepTraining:                     return "figure.step.training"
        case .wheelchairWalkPace:               return "figure.roll"
        case .wheelchairRunPace:                return "figure.roll.runningpace"

        case .taiChi:                           return "figure.taichi"
        case .mixedCardio:                      return "figure.mixed.cardio"
        case .handCycling:                      return "figure.hand.cycling"

        case .discSports:                       return "figure.disc.sports"
        case .fitnessGaming:                    return "figure.water.fitness"

        default:                                return "figure.strengthtraining.functional"
        }
    }

    // Mapowanie dostepnych typow aktywnosci na pasujace emotikony
    var associatedEmoji: String? {
        switch self {
        case .americanFootball:                 return "🏈"
        case .archery:                          return "🏹"
        case .badminton:                        return "🏸"
        case .baseball:                         return "⚾️"
        case .basketball:                       return "🏀"
        case .bowling:                          return "🎳"
        case .boxing:                           return "🥊"
        case .curling:                          return "🥌"
        case .cycling:                          return "🚲"
        case .equestrianSports:                 return "🏇"
        case .fencing:                          return "🤺"
        case .fishing:                          return "🎣"
        case .functionalStrengthTraining:       return "💪"
        case .golf:                             return "⛳️"
        case .hiking:                           return "🥾"
        case .hockey:                           return "🏒"
        case .lacrosse:                         return "🥍"
        case .martialArts:                      return "🥋"
        case .mixedMetabolicCardioTraining:     return "❤️"
        case .paddleSports:                     return "🛶"
        case .rowing:                           return "🛶"
        case .rugby:                            return "🏉"
        case .sailing:                          return "⛵️"
        case .skatingSports:                    return "⛸"
        case .snowSports:                       return "🛷"
        case .soccer:                           return "⚽️"
        case .softball:                         return "🥎"
        case .tableTennis:                      return "🏓"
        case .tennis:                           return "🎾"
        case .traditionalStrengthTraining:      return "🏋️‍♂️"
        case .volleyball:                       return "🏐"
        case .waterFitness, .waterSports:       return "💧"

        case .barre:                            return "🥿"
        case .crossCountrySkiing:               return "⛷"
        case .downhillSkiing:                   return "⛷"
        case .kickboxing:                       return "🥋"
        case .snowboarding:                     return "🏂"

        case .mixedCardio:                      return "❤️"

        case .discSports:                       return "🥏"
        case .fitnessGaming:                    return "🎮"

        default:                                return nil
        }
    }

}
