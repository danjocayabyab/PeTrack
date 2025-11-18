//
//  MyPetsView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI

struct MyPetsView: View {
    @StateObject private var viewModel = MyPetsViewModel()

    @State private var showAddPet = false
    @State private var showDetails = false
    @State private var showMenu = false
    @State private var showEdit = false

    @State private var selectedPet: Pet? = nil

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            VStack(spacing: 20) {
                SearchBar(text: $viewModel.searchText)
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
                        ForEach(viewModel.filteredPets) { pet in
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
                viewModel.addPet(newPet)
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
                    viewModel.updatePet(updated)
                }
                .presentationDetents([.large])
            }
        }
        // 3-dot menu
        .confirmationDialog("Actions", isPresented: $showMenu, titleVisibility: .visible) {
            Button("Edit") { showEdit = true }
            Button("Delete", role: .destructive) {
                if let pet = selectedPet { viewModel.deletePet(pet) }
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("My Pets")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Image(systemName: "pawprint.fill")
                    .font(.title2).foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text(viewModel.petCountText)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 30)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}
