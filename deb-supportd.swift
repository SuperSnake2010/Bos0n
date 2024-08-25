import Foundation

// Function to execute a shell command
func runCommand(_ command: String, currentDirectory: String) {
    // Create a Process instance
    let process = Process()
    
    // Set the executable to Bash
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    
    // Pass the command to Bash
    process.arguments = ["-c", command]
    
    // Set the current working directory
    process.currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
    
    // Set up pipes to capture output and error streams
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    
    process.standardOutput = outputPipe
    process.standardError = errorPipe
    
    do {
        // Launch the process
        try process.run()
        
        // Capture and print standard output
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let outputString = String(data: outputData, encoding: .utf8) {
            print("Output:\n\(outputString)")
        }
        
        // Capture and print standard error
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
            print("Error:\n\(errorString)")
        }
        
        // Wait until the process completes
        process.waitUntilExit()
        
    } catch {
        print("Error running command: \(error)")
    }
}

// Define the command to run
let command = "npm install adm-zip 7zip-bin"

// Get the current working directory
let currentDirectory = FileManager.default.currentDirectoryPath

