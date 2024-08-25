import Foundation

// Export running app as .ipa, then return path to exported file.
// Returns String because app crashes when returning URL from async function for some reason...
func exportIPA() async throws -> String
{
    // Path to app bundle
    let bundleURL = Bundle.main.bundleURL
    
    // Create Payload/ directory
    let temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let payloadDirectory = temporaryDirectory.appendingPathComponent("Payload")
    try FileManager.default.createDirectory(at: payloadDirectory, withIntermediateDirectories: true, attributes: nil)
    
    defer {
        // Remove temporary directory
        try? FileManager.default.removeItem(at: temporaryDirectory)
    }
    
    let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "App"
    let appURL = payloadDirectory.appendingPathComponent("\(appName).app")
    let ipaURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(appName).ipa")
    
    // Copy app bundle to Payload/
    try FileManager.default.copyItem(at: bundleURL, to: appURL)
    
    // Remove occurrences of "swift-playgrounds-" from bundle identifier.
    // (Apple forbids registering App IDs containing that string)
    let bundleID = Bundle.main.bundleIdentifier!
    let updatedBundleID = bundleID.replacingOccurrences(of: "swift-playgrounds-", with: "")
    
    // Update bundle identifier
    let plistURL = appURL.appendingPathComponent("Info.plist")
    let infoPlist = try NSMutableDictionary(contentsOf: plistURL, error: ())
    infoPlist[kCFBundleIdentifierKey as String] = updatedBundleID
    try infoPlist.write(to: plistURL) 
    
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
        // Coordinating read access to Payload/ "forUploading" automatically zips the directory for us.
        let readIntent = NSFileAccessIntent.readingIntent(with: payloadDirectory, options: .forUploading)
        
        let fileCoordinator = NSFileCoordinator()
        fileCoordinator.coordinate(with: [readIntent], queue: .main) { error in
            do
            {
                guard error == nil else { throw error! }
                
                // Change file extension from "zip" to "ipa"
                _ = try FileManager.default.replaceItemAt(ipaURL, withItemAt: readIntent.url)
                
                print("Exported .ipa:", ipaURL)
                continuation.resume()
            }
            catch
            {
                print("Failed to export .ipa:", error)
                continuation.resume(throwing: error)
            }
        }
    }
    
    return ipaURL.path
}
