//
//  UIPrimitives.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

// MARK: - Views/Components/UIPrimitives.swift
import SwiftUI

/// Small rounded tag used across rows (pet name, category, etc.)
struct PillBadge: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.14))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .lineLimit(1)
            .minimumScaleFactor(0.9)
    }
}

/// 26x26 square icon button (edit/trash)
struct IconSquareButton: View {
    let systemName: String
    let tint: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(tint)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .fixedSize()
    }
}

/// Hex color helper (e.g., "#F59E0B")
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a,r,g,b) = (255, (int>>8)*17, (int>>4 & 0xF)*17, (int & 0xF)*17)
        case 6: (a,r,g,b) = (255, int>>16, int>>8 & 0xFF, int & 0xFF)
        case 8: (a,r,g,b) = (int>>24, int>>16 & 0xFF, int>>8 & 0xFF, int & 0xFF)
        default:(a,r,g,b) = (255, 0, 122, 255)
        }
        self.init(.sRGB,
                  red: Double(r)/255,
                  green: Double(g)/255,
                  blue: Double(b)/255,
                  opacity: Double(a)/255)
    }
}
