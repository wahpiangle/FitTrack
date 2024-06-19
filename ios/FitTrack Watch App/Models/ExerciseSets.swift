//
//  ExerciseSets.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 16/06/2024.
//

import Foundation

class ExerciseSets{
    var id: Int
    var reps: Int
    var weight: Double
    
    init(id: Int, reps: Int, weight: Double) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }
}
