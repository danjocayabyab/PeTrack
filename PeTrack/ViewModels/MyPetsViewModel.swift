//
//  MyPetsViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class MyPetsViewModel: ObservableObject {
    @Published private(set) var pets: [Pet] = []
    @Published var searchText: String = ""
    
    internal var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchPets()
    }
    
    var filteredPets: [Pet] {
        if searchText.isEmpty { return pets }
        return pets.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.breed.localizedCaseInsensitiveContains(searchText) }
    }
    
    var petCount: Int { pets.count }
    var petCountText: String { "\(petCount) Furry Friends" }
    
    // MARK: - Data Operations
    func fetchPets() {
        let descriptor = FetchDescriptor<Pet>(sortBy: [SortDescriptor(\.name)])
        do {
            pets = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch pets: \(error.localizedDescription)")
        }
    }
    
    func addPet(_ pet: Pet) {
        print("Adding pet to context: \(pet)")
        modelContext.insert(pet)
        print("Pet inserted into context, saving...")
        saveContext()
        print("Context saved, fetching updated pets...")
        fetchPets()
        print("Total pets after add: \(pets.count)")
    }
    
    func updatePet(_ updated: Pet) {
        saveContext()
        fetchPets()
    }
    
    func deletePet(_ pet: Pet) {
        modelContext.delete(pet)
        saveContext()
        fetchPets()
    }
    
    private func saveContext() {
        do {
            print("Saving context...")
            try modelContext.save()
            print("Context saved successfully")
        } catch {
            print("Failed to save context: \(error)")
            print("Detailed error: \(error.localizedDescription)")
        }
    }
}

