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
        VStack(alignment: .leading) {
            
//            Text("Quick Start")
//                .font(.headline)
//                .padding()
//            Button(action:{
//                print(viewModel.templates)
//            }, label:
//                {
//                Text("Start New Workout")
//                    .foregroundColor(Color.black)
//            })
//                .background(Color.theme.secondary)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//            Text("My Templates")
//                .font(.headline)
//                .padding()
//            Text(viewModel.templates.count > 0 ? "You have \(viewModel.templates.count) templates" : "You have no templates")
//                .padding()
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
