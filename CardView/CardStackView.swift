//
//  CardStackView.swift
//  CardView
//
//  A stack of animated cards with tap and drag interactions
//

import SwiftUI

struct CardStackView: View {
    @State private var cards: [Card] = Card.sampleCards
    @State private var tappedCardIndex: Int? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var dragCardIndex: Int? = nil
    
    // Card stack configuration
    private let cardSpacing: CGFloat = 20
    private let maxVisibleCards = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.15),
                        Color(red: 0.15, green: 0.15, blue: 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Title
                    Text("Animated Card Deck")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // Card Stack
                    ZStack {
                        ForEach(Array(cards.prefix(maxVisibleCards).enumerated()), id: \.element.id) { index, card in
                            CardView(
                                card: card,
                                index: index,
                                isTapped: .constant(tappedCardIndex == index)
                            )
                            .frame(
                                width: geometry.size.width * 0.85,
                                height: geometry.size.height * 0.5
                            )
                            .offset(
                                x: index == dragCardIndex ? dragOffset.width : 0,
                                y: index == dragCardIndex ? dragOffset.height : CGFloat(index) * cardSpacing
                            )
                            .scaleEffect(
                                index == dragCardIndex ? 1.05 : 1.0 - CGFloat(index) * 0.05
                            )
                            .rotationEffect(
                                .degrees(
                                    index == dragCardIndex ? Double(dragOffset.width / 20) : 0
                                )
                            )
                            .opacity(index < maxVisibleCards ? 1.0 - Double(index) * 0.15 : 0)
                            .zIndex(index == dragCardIndex ? Double(maxVisibleCards + 1) : Double(maxVisibleCards - index))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if dragCardIndex == nil {
                                            dragCardIndex = index
                                        }
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        handleDragEnd(value: value, cardIndex: index)
                                    }
                            )
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        handleCardTap(index: index)
                                    }
                            )
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.7),
                                value: tappedCardIndex
                            )
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8),
                                value: dragOffset
                            )
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8),
                                value: dragCardIndex
                            )
                        }
                    }
                    .frame(height: geometry.size.height * 0.5)
                    
                    Spacer()
                    
                    // Instructions
                    VStack(spacing: 12) {
                        Text("Tap a card to animate")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Drag to move cards")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // Handle card tap animation
    private func handleCardTap(index: Int) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            if tappedCardIndex == index {
                tappedCardIndex = nil
            } else {
                tappedCardIndex = index
            }
        }
        
        // Reset tap after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                tappedCardIndex = nil
            }
        }
    }
    
    // Handle drag end - snap back or dismiss card
    private func handleDragEnd(value: DragGesture.Value, cardIndex: Int) {
        let threshold: CGFloat = 100
        
        if abs(value.translation.width) > threshold || abs(value.translation.height) > threshold {
            // Dismiss card
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                if !cards.isEmpty {
                    cards.removeFirst()
                }
            }
        } else {
            // Snap back
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                dragOffset = .zero
            }
        }
        
        // Reset drag state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragCardIndex = nil
            dragOffset = .zero
        }
    }
}

#Preview {
    CardStackView()
}

