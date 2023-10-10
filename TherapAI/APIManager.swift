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
        
        let bodyData = "text=\(text)&user_id=\(userID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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

