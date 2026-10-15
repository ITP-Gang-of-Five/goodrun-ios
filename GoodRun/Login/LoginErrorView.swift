//
//  RouteOrderErrorView.swift
//  GoodRun
//
//  Created by Max Healey on 13/10/2026.
//
import SwiftUI

struct LoginErrorView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.left.and.right.circle.fill")
                .foregroundColor(.red)
            Text("Login Error")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 5)
        .transition(.move(edge: .top).combined(with: .opacity))
        .padding(.top, 10)
        .frame(maxHeight: .infinity, alignment: .leading)
    }
}
