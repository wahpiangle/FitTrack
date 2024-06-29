import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var counter = 0
    @Published var templates: Array<WorkoutTemplate> = []
    
    
    // receiving from phone to watch
    enum WatchReceiveMethod: String {
        case sendTemplatesToWatch
        case sendCounterToNative
    }
    
    // sending from watch to phone
    enum WatchSendMethod: String {
        case sendCounterToFlutter
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        self.templates.append(WorkoutTemplate(id: 1, title: "Test", note: "Test", exerciseSetsInfo: [
            ExerciseSetsInfo(exerciseId: 1, exerciseName: "Test", bodyPart: "Test", category: "Test", sets: [
                ExerciseSets(id: 1, reps: 1, weight: 1.0)
            ])
        ]))
    }
    
    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        sendMessage(for: method.rawValue, data: data)
    }
    
}

extension WatchViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Receive message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            
            switch enumMethod {
            case .sendCounterToNative:
                self.counter = (message["data"] as? Int) ?? 0
            
            case .sendTemplatesToWatch:
                let workoutTemplatesData = WorkoutTemplate.fromJson(
                    json: (message["data"] as! Array<[String: Any]>)
                )
                print(message["data"] as! Array<[String: Any]>)
                self.templates = workoutTemplatesData
                                                           
            }
            
        }
    }
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            return
        }
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}