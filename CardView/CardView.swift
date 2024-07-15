//
//  CardView.swift
//  CardView
//
//  A beautiful, animated card component with gradients and shadows
//

import SwiftUI

struct CardView: View {
    let card: Card
    let index: Int
    @Binding var isTapped: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient Background
                LinearGradient(
                    colors: card.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(24)
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: isTapped ? 20 : 10,
                    x: 0,
                    y: isTapped ? 10 : 5
                )
                
                // Card Content
                VStack(alignment: .leading, spacing: 16) {
                    // Icon
                    Image(systemName: card.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    // Title
                    Text(card.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Subtitle
                    Text(card.subtitle)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// Card Data Model
struct Card: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let gradientColors: [Color]
}

// Sample Card Data
extension Card {
    static let sampleCards: [Card] = [
        Card(
            title: "Design",
            subtitle: "Create beautiful interfaces",
            icon: "paintbrush.fill",
            gradientColors: [Color(red: 0.97, green: 0.45, blue: 0.45), Color(red: 0.94, green: 0.25, blue: 0.47)]
        ),
        Card(
            title: "Code",
            subtitle: "Build amazing apps",
            icon: "laptopcomputer",
            gradientColors: [Color(red: 0.36, green: 0.73, blue: 0.97), Color(red: 0.20, green: 0.60, blue: 0.86)]
        ),
        Card(
            title: "Ship",
            subtitle: "Launch to the world",
            icon: "rocket.fill",
            gradientColors: [Color(red: 0.58, green: 0.45, blue: 0.97), Color(red: 0.40, green: 0.30, blue: 0.85)]
        ),
        Card(
            title: "Grow",
            subtitle: "Scale your product",
            icon: "chart.line.uptrend.xyaxis",
            gradientColors: [Color(red: 0.97, green: 0.65, blue: 0.45), Color(red: 0.94, green: 0.50, blue: 0.25)]
        ),
        Card(
            title: "Learn",
            subtitle: "Never stop improving",
            icon: "book.fill",
            gradientColors: [Color(red: 0.45, green: 0.97, blue: 0.65), Color(red: 0.25, green: 0.85, blue: 0.50)]
        )
    ]
}

#Preview {
    CardView(
        card: Card.sampleCards[0],
        index: 0,
        isTapped: .constant(false)
    )
    .frame(width: 300, height: 400)
    .padding()
}

