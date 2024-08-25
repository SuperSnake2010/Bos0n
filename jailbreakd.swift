func testMemmove() {
    let bufferSize = 64
    let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
    
    // Initialize buffer with 'A' (ASCII value 65)
    buffer.initialize(repeating: CChar(65), count: bufferSize)
    
    // Define source and destination pointers
    let src = buffer.advanced(by: 10)
    let dst = buffer.advanced(by: 5)
    
    // Perform memmove with an overlapping region
    libkernel_memmove(dst, src, 20)
    
    // Print buffer content for verification
    let bufferContent = String(cString: buffer)
    print("Buffer content after memmove: \(bufferContent)")
    
    // Deinitialize and deallocate buffer
    buffer.deinitialize(count: bufferSize)
    buffer.deallocate()
    
    // Run JavaScript code after buffer operations
    runJavaScriptCode()
}

