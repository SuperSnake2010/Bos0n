
import Foundation // Ensure this import is included

// Define a function to run the command
func runCommand(command: String, currentDirectory: String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/zsh") // Adjust to your shell if necessary
    process.arguments = ["-c", command]
    process.currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
    
    do {
        try process.run()
        process.waitUntilExit()
        print("Command executed successfully")
    } catch {
        print("Error running command: \(error)")
    }
}

struct ContentView: View {
    // Define the command and directory
    let command = "echo 'Hello, World!'" // Replace with your actual command
    let currentDirectory = FileManager.default.currentDirectoryPath
    
    var body: some View {
        VStack {
            Text("Run Command Example")
                .padding()
            
            Button(action: {
                runCommand(command: command, currentDirectory: currentDirectory)
            }) {
                Text("Run Command")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
