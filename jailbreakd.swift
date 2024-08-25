import Foundation

func testMemmove() {
    let bufferSize = 64
    let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
    
    // Initialize buffer with 'A' (ASCII value 65)
    buffer.initialize(repeating: CChar(65), count: bufferSize)
    
    // Define source and destination pointers
    let src = buffer.advanced(by: 10)
    let dst = buffer.advanced(by: 5)
    
    // Intentionally trigger a buffer overflow by moving more data than available
    let overlapSize = 100 // Intentionally large size to exceed buffer bounds
    memmove(dst, src, overlapSize)
    
    // Print buffer content for verification (might not be accurate due to overflow)
    let bufferContent = String(cString: buffer)
    print("Buffer content after memmove: \(bufferContent)")
    
    // Deinitialize and deallocate buffer
    buffer.deinitialize(count: bufferSize)
    buffer.deallocate()
    
    // Run JavaScript code after buffer operations
    runJavaScriptCode()
}

func runJavaScriptCode() {
    // Example JavaScript execution, placeholder function
    print("JavaScript code execution placeholder.")
}
