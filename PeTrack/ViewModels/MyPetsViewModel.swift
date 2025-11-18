//
//  MyPetsViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import Foundation
import SwiftUI

class MyPetsViewModel: ObservableObject {
    @Published var pets: [Pet] = Pet.mockPets
    @Published var searchText: String = ""

    var filteredPets: [Pet] {
        if searchText.isEmpty { return pets }
        return pets.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.breed.localizedCaseInsensitiveContains(searchText) }
    }

    var petCount: Int { pets.count }
    var petCountText: String { "\(petCount) Furry Friends" }

    func addPet(_ pet: Pet) {
        pets.append(pet)
    }

    func updatePet(_ updated: Pet) {
        if let i = pets.firstIndex(where: { $0.id == updated.id }) {
            pets[i] = updated
        }
    }

    func deletePet(_ pet: Pet) {
        pets.removeAll { $0.id == pet.id }
    }
}

