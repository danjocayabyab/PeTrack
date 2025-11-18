//
//  Pet.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//


import Foundation
import SwiftData

@Model
final class Pet: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var breed: String
    var age: String
    var ageInYears: Int
    var gender: String
    var weight: String
    var imageURL: String?
    var avatarColor: String
    var timestamp: Date

    init(id: UUID = UUID(),
         name: String,
         breed: String,
         age: String,
         ageInYears: Int,
         gender: String,
         weight: String,
         imageURL: String? = nil,
         avatarColor: String,
         timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.ageInYears = ageInYears
        self.gender = gender
        self.weight = weight
        self.imageURL = imageURL
        self.avatarColor = avatarColor
        self.timestamp = timestamp
    }
}
