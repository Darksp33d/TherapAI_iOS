import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    func postMessage(text: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://therapai-4bfe081d185e.herokuapp.com/process_text")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "text=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        request.httpBody = body?.data(using: .utf8)
        
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
