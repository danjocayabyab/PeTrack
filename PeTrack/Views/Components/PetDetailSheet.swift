//
//  PetDetailSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct PetDetailSheet: View {
    let pet: Pet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Avatar
                    Circle()
                        .fill(avatarColor)
                        .frame(width: 84, height: 84)
                        .overlay(
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                        .padding(.top, 16)

                    // Card with basic info
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.purple)
                            Text("Basic Information")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }

                        InfoRow(label: "Name",   value: pet.name)
                        InfoRow(label: "Breed",  value: pet.breed)
                        InfoRow(label: "Gender", value: pet.gender)
                        InfoRow(label: "Age",    value: pet.age)
                        InfoRow(label: "Weight", value: pet.weight)
                        InfoRow(label: "Color",  value: humanColor)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.12)))
                    .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    private var avatarColor: Color {
        switch pet.avatarColor.lowercased() {
        case "orange": return .orange
        case "gray":   return .gray
        case "brown":  return .brown
        default:       return .blue
        }
    }
    private var humanColor: String {
        switch pet.avatarColor.lowercased() {
        case "orange": return "Orange"
        case "gray":   return "Gray"
        case "brown":  return "Brown"
        default:       return "Blue"
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.system(size: 15))
    }
}
