import Foundation

class APIManager {
    
    static let shared = APIManager()

    // Retrieve the hashed UUID (as an integer) from UserDefaults
    private var userID: Int {
        if let storedUUID = UserDefaults.standard.value(forKey: "userUUIDHash") as? Int {
            return storedUUID
        } else {
            // Generate, save, and return a new UUID hash
            let newUUIDHash = abs(UUID().hashValue)
            UserDefaults.standard.setValue(newUUIDHash, forKey: "userUUIDHash")
            return newUUIDHash
        }
    }

    
    func addJournalEntry(content: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/add_journal_entry")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyData = "content=\(content)&user_id=\(userID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        request.httpBody = bodyData?.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = jsonResponse["success"] as? Bool {
                completion(success)
            } else {
                completion(false)
            }
        }.resume()
    }

    func getJournalEntries(completion: @escaping ([(date: String, content: String)]) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/get_journal_entries?user_id=\(userID)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            if let entries = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                completion(entries.map { (date: $0["date"] ?? "", content: $0["content"] ?? "") })
            } else {
                completion([])
            }
        }.resume()
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

}

