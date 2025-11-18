//
//  MyPetsView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI
import SwiftData

struct MyPetsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.name) private var pets: [Pet]
    @State private var searchText = ""

    @State private var showAddPet = false
    @State private var showDetails = false
    @State private var showMenu = false
    @State private var showEdit = false

    @State private var selectedPet: Pet? = nil
    
    var filteredPets: [Pet] {
        if searchText.isEmpty {
            return pets
        }
        return pets.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) || 
            $0.breed.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            // Debug info
            .onAppear {
                print("MyPetsView appeared")
                print("Current number of pets in @Query: \(pets.count)")
                print("Filtered pets count: \(filteredPets.count)")
                print("Search text: \"\(searchText)\"")
            }

            VStack(spacing: 20) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 20)

                HStack {
                    Spacer()
                    Button(action: { showAddPet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus").font(.system(size: 16, weight: .medium))
                            Text("Add Pet").font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 25).stroke(Color.gray.opacity(0.3)))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredPets) { pet in
                            PetListCard(
                                pet: pet,
                                onMenuTap: {
                                    selectedPet = pet
                                    showMenu = true
                                }
                            )
                            .onTapGesture {
                                selectedPet = pet
                                showDetails = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
        // Add Pet
        .sheet(isPresented: $showAddPet) {
            AddPetSheet { newPet in
                print("AddPetSheet completion called with new pet: \(newPet)")
                // Add the pet directly to the environment's context
                modelContext.insert(newPet)
                do {
                    try modelContext.save()
                    print("Pet saved successfully to context")
                } catch {
                    print("Failed to save pet: \(error)")
                }
            }
            .presentationDetents([.large])
        }
        // Details
        .sheet(isPresented: $showDetails) {
            if let pet = selectedPet {
                PetDetailSheet(pet: pet)
            }
        }
        // Edit
        .sheet(isPresented: $showEdit) {
            if let pet = selectedPet {
                EditPetSheet(original: pet) { updated in
                    // The pet is already updated in place by the EditPetSheet
                    do {
                        try modelContext.save()
                        print("Pet updated successfully")
                    } catch {
                        print("Failed to update pet: \(error)")
                    }
                }
                .presentationDetents([.large])
            }
        }
        // 3-dot menu
        .confirmationDialog("Actions", isPresented: $showMenu, titleVisibility: .visible) {
            Button("Edit") { showEdit = true }
            Button("Delete", role: .destructive) {
                if let pet = selectedPet {
                    modelContext.delete(pet)
                    do {
                        try modelContext.save()
                        print("Pet deleted successfully")
                    } catch {
                        print("Failed to delete pet: \(error)")
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Pets")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)
            
            Text("\(filteredPets.count) pets")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}
