//
//  ContentView.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 11/06/2024.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    
    var body: some View {
        VStack {
            Text("Counter: \(viewModel.counter)")
                .padding()
            Button(action: {
                viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.counter + 1])
            }) {
                Text("+ by 2")
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
