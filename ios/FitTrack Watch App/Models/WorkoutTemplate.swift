//
//  WorkoutTemplate.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 16/06/2024.
//

import Foundation

class WorkoutTemplate {
    var id: Int
    var title: String
    var note: String
    var exerciseSetsInfo: Array<ExerciseSetsInfo>
    
    init(id: Int, title: String, note: String, exerciseSetsInfo: Array<ExerciseSetsInfo>) {
        self.id = id
        self.title = title
        self.note = note
        self.exerciseSetsInfo = exerciseSetsInfo
    }
    
    static func fromJson(json: Array<[String: Any]>) -> Array<WorkoutTemplate> {
        var workoutTemplates: Array<WorkoutTemplate> = []
        for data in json{
            let id = data["id"] as? Int
            let title = data["title"] as? String
            let note = data["note"] as? String
            let exerciseSetsInfoData = data["exerciseSetsInfo"] as? Array<[String: Any]>
            var exerciseSetsInfo: Array<ExerciseSetsInfo> = []
            for exerciseSetInfoData in exerciseSetsInfoData! {
                let exerciseId = exerciseSetInfoData["exerciseId"] as? Int
                let exerciseName = exerciseSetInfoData["exerciseName"] as? String
                let bodyPart = exerciseSetInfoData["bodyPart"] as? String
                let category = exerciseSetInfoData["category"] as? String
                let setsData = exerciseSetInfoData["sets"] as? Array<[String: Any]>
                var sets = Array<ExerciseSets>()
                for setData in setsData! {
                    let id = setData["id"] as! Int
                    let reps = setData["reps"] as! Int
                    let weight = setData["weight"] as! Double
                    let exerciseSet = ExerciseSets(id: id, reps: reps, weight: weight)
                    sets.append(exerciseSet)
                }
                exerciseSetsInfo.append(ExerciseSetsInfo(exerciseId: exerciseId!, exerciseName: exerciseName!, bodyPart: bodyPart!, category: category!, sets: sets))
            }
             workoutTemplates.append(WorkoutTemplate(id: id!, title: title!, note: note!, exerciseSetsInfo: exerciseSetsInfo))
        }
        return workoutTemplates
        
    }
}
