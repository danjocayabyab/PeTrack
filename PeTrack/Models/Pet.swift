//
//  Pet.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//


import Foundation
import SwiftData

@Model
final class Pet {
    var id: UUID
    var name: String
    var breed: String
    var age: String
    var ageInYears: Int
    var gender: String
    var weight: String
    var imageURL: String?
    var avatarColor: String

    init(id: UUID = UUID(),
         name: String,
         breed: String,
         age: String,
         ageInYears: Int,
         gender: String,
         weight: String,
         imageURL: String? = nil,
         avatarColor: String) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.ageInYears = ageInYears
        self.gender = gender
        self.weight = weight
        self.imageURL = imageURL
        self.avatarColor = avatarColor
    }

    // Seed mocks
    static let mockPets: [Pet] = [
        Pet(name: "Buddy", breed: "Golden Retriever", age: "3 years old", ageInYears: 3, gender: "Male", weight: "30.5 kg", avatarColor: "orange"),
        Pet(name: "Luna",  breed: "Persian Cat",      age: "2 years old", ageInYears: 2, gender: "Female", weight: "4.2 kg",  avatarColor: "gray"),
        Pet(name: "Max",   breed: "Beagle",           age: "5 years old", ageInYears: 5, gender: "Male", weight: "15.8 kg",  avatarColor: "brown")
    ]
}
