import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            Text("Bos0n")
                .font(.system(size: 72))
                .fontWeight(.bold)
                .padding()
            
            Button(action: {
                // Call the Swift function that interacts with C code
                testMemmove()
            }) {
                Text("Jailbreak!")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text("jailbreak by stanley the great")
                .font(.footnote)
                .padding()
        }
        .padding()
    }
}

