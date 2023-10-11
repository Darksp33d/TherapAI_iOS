import Foundation

class APIManager {
    
    static let shared = APIManager()

    // Retrieve the hashed UUID (as an integer) from UserDefaults
    private var userID: Int {
        return UserDefaults.standard.integer(forKey: "userUUIDHash")
    }
    
    func postMessage(text: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/process_text")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Print the userID to the Xcode logs
        print("Sending message for userID:", userID)
        var completeText = text
                if let name = UserDefaults.standard.string(forKey: "userName") {
                    completeText = "My name is \(name). \(text)"
                }

                let bodyData = "text=\(completeText)&user_id=\(userID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        request.httpBody = bodyData?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let responseText = jsonResponse["response"] as? String {
                    completion(responseText)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func saveMood(moods: [String], completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/save_mood")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let moodsString = moods.joined(separator: ",")
        let bodyData = "mood=\(moodsString)&user_id=\(userID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        request.httpBody = bodyData?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], jsonResponse["response"] != nil {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func hasSubmittedMoodToday(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/has_submitted_mood?user_id=\(userID)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let hasSubmitted = jsonResponse["hasSubmitted"] as? Bool {
                completion(hasSubmitted)
            } else {
                completion(false)
            }
        }.resume()
    }


    func fetchMoods(timeframe: MoodTrackerView.GraphTimeframe, completion: @escaping ([(date: String, count: Int)]) -> Void) {
        let endpoint: String
        switch timeframe {
        case .weekly:
            endpoint = "https://therapai-4bfe081d185e.herokuapp.com/fetch_weekly_moods"
        case .monthly:
            endpoint = "https://therapai-4bfe081d185e.herokuapp.com/fetch_monthly_moods"
        }

        let url = URL(string: "\(endpoint)?user_id=\(userID)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] {
                // Transform the dictionary into the required array of tuples
                let moodList = jsonResponse.compactMap { (date: $0.key, count: $0.value) }
                completion(moodList)
            } else {
                completion([])
            }
        }.resume()
    }




}

