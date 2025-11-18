//
//  AddPetSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

// MARK: - Views/Components/AddPetSheet.swift
import SwiftUI
import PhotosUI

struct AddPetSheet: View {
    // Return the created Pet to the caller
    var onSave: (Pet) -> Void
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var gender: String = ""   // "Male" or "Female"
    @State private var ageYears: Int = 1
    @State private var weightKg: Double = 0.5
    @State private var colorText: String = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Add New Pet")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 8)
                    Text("Fill in the details to add a new pet to your collection")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)

                    // BASIC INFO CARD
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                            Text("Basic Information")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            LabeledField("Pet Name") {
                                TextField("Enter Pet Name", text: $name)
                                    .textFieldStyle(SoftFieldStyle())
                            }

                            LabeledField("Breed") {
                                TextField("Enter Breed", text: $breed)
                                    .textFieldStyle(SoftFieldStyle())
                            }

                            LabeledField("Gender") {
                                HStack(spacing: 16) {
                                    SelectablePill(title: "Male",   isSelected: gender == "Male")   { gender = "Male" }
                                    SelectablePill(title: "Female", isSelected: gender == "Female") { gender = "Female" }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue.opacity(0.5), lineWidth: 2))

                    // PHYSICAL DETAILS CARD
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "pawprint.circle")
                                .foregroundColor(.blue)
                            Text("Physical Details")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            // Age Stepper (custom +/- like your mock)
                            LabeledField("Age") {
                                HStack(spacing: 14) {
                                    RoundIconButton(systemName: "minus") { ageYears = max(0, ageYears - 1) }
                                    Text("\(ageYears)")
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(minWidth: 28)
                                    RoundIconButton(systemName: "plus") { ageYears += 1 }
                                    Spacer()
                                }
                            }

                            // Weight slider 0.5–50kg
                            LabeledField("Weight") {
                                VStack(alignment: .leading, spacing: 8) {
                                    Slider(value: $weightKg, in: 0.5...50, step: 0.5)
                                    HStack {
                                        Text("0.5 kg")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("50 kg")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }

                            // Color (for avatar color tag)
                            LabeledField("Color") {
                                TextField("Enter Color", text: $colorText)
                                    .textFieldStyle(SoftFieldStyle())
                            }
                        }
                    }

                    // PHOTO CARD (Optional)
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.circle")
                                .foregroundColor(.blue)
                            Text("Photo")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }

                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15))
                                if let img = selectedImage {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 64, height: 64)
                            .clipped()
                            .cornerRadius(10)

                            PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                                Text("Choose Photo")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.35), lineWidth: 1))
                            }
                            .onChange(of: photoItem) { oldValue, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                                       let img = UIImage(data: data) {
                                        selectedImage = img
                                    }
                                }
                            }

                            Text("Optional")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }

                    // Actions
                    HStack(spacing: 16) {
                        // Primary
                        Button(action: handleSave) {
                            Text("Add Pet")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black))
                        }

                        // Cancel
                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.35)))
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal)
            }
            .interactiveDismissDisabled() // avoid swipe-dismiss while filling
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    // MARK: - Build Pet + Save
    private func handleSave() {
        // Basic validation
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Validation failed: Name is empty")
            return
        }
        guard !breed.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Validation failed: Breed is empty")
            return
        }
        guard gender == "Male" || gender == "Female" else {
            print("Validation failed: Invalid gender")
            return
        }

        let ageString = "\(ageYears) year" + (ageYears == 1 ? "" : "s") + " old"
        let weightString = String(format: "%.1f kg", weightKg)
        let avatarColor = normalizedAvatarColor(from: colorText)
        
        print("Creating new pet with name: \(name), breed: \(breed)")

        let newPet = Pet(
            name: name,
            breed: breed,
            age: ageString,
            ageInYears: ageYears,
            gender: gender,
            weight: weightString,
            imageURL: nil,
            avatarColor: avatarColor,
            timestamp: Date()
        )
        
        print("New pet created: \(newPet)")
        onSave(newPet)
        print("Pet saved, dismissing sheet")
        dismiss()
    }

    // Map user color text to one of your avatarColor keys
    private func normalizedAvatarColor(from input: String) -> String {
        let key = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch key {
        case "orange", "amber": return "orange"
        case "gray", "grey", "silver": return "gray"
        case "brown", "tan": return "brown"
        default: return "blue"
        }
    }
}

// MARK: - Small UI helpers

private struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 16) { content }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08)))
            .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

private struct LabeledField<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title; self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 14, weight: .semibold))
            content
        }
    }
}

private struct SoftFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
    }
}

private struct SelectablePill: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.35), lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
        .frame(width: 150) // match your mock sizes
    }
}

private struct RoundIconButton: View {
    let systemName: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.35)))
        }
        .buttonStyle(.plain)
    }
}
