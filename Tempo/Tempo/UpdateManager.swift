import Foundation
import AppKit
import Combine

final class UpdateManager: ObservableObject {
    static let shared = UpdateManager()
    
    @Published var isChecking: Bool = false
    @Published var updateAvailable: Bool = false
    @Published var latestVersion: String = ""
    @Published var releaseNotes: String = ""
    @Published var downloadURL: String = ""
    @Published var errorMessage: String?
    
    let currentVersion: String
    private let repoOwner: String
    private let repoName: String
    
    private init() {
        self.currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        self.repoOwner = "backtosq1"
        self.repoName = "Tempo"
    }
    
    func checkForUpdates() {
        isChecking = true
        errorMessage = nil
        updateAvailable = false
        
        let urlString = "https://api.github.com/repos/\(repoOwner)/\(repoName)/releases/latest"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isChecking = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Tempo/1.0", forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isChecking = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let tagName = json["tag_name"] as? String {
                        
                        let latestVersion = tagName.replacingOccurrences(of: "v", with: "")
                        self?.latestVersion = latestVersion
                        self?.downloadURL = json["html_url"] as? String ?? ""
                        self?.releaseNotes = json["body"] as? String ?? ""
                        
                        if self?.compareVersions(self?.currentVersion ?? "", latestVersion) == .orderedAscending {
                            self?.updateAvailable = true
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
    
    func openDownloadPage() {
        if let url = URL(string: downloadURL) {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func compareVersions(_ v1: String, _ v2: String) -> ComparisonResult {
        let v1Components = v1.split(separator: ".").compactMap { Int($0) }
        let v2Components = v2.split(separator: ".").compactMap { Int($0) }
        
        let maxLength = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxLength {
            let v1Value = i < v1Components.count ? v1Components[i] : 0
            let v2Value = i < v2Components.count ? v2Components[i] : 0
            
            if v1Value < v2Value {
                return .orderedAscending
            } else if v1Value > v2Value {
                return .orderedDescending
            }
        }
        
        return .orderedSame
    }
}
