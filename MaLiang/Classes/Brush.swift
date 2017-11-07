//
//  Brush.swift
//  MaLiang
//
//  Created by Harley.xk on 2017/11/6.
//

import Foundation
import OpenGLES
import UIKit

open class Brush {
    
    var id: GLuint = 0
    var width: GLsizei = 0
    var height: GLsizei = 0
    
    var texture: UIImage
    open var opacity: Float = 0.3
    open var pixelStep = 3
    open var scale = 2
    
    public init(texture: UIImage) {
        self.texture = texture
    }
    
    // Create texture for brush
    open func createTexture() {
        
        var texId: GLuint = 0
        
        // First create a UIImage object from the data in a image file, and then extract the Core Graphics image
        let brushImage = texture.cgImage
        
        // Get the width and height of the image
        let width: size_t = brushImage?.width ?? 0
        let height: size_t = brushImage?.height ?? 0
        
        // Make sure the image exists
        if brushImage != nil {
            // Allocate  memory needed for the bitmap context
            var brushData = [GLubyte](repeating: 0, count: width * height * 4)
            // Use  the bitmatp creation function provided by the Core Graphics framework.
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
            let brushContext = CGContext(data: &brushData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: (brushImage?.colorSpace!)!, bitmapInfo: bitmapInfo)
            // After you create the context, you can draw the  image to the context.
            brushContext?.draw(brushImage!, in: CGRect(x: 0.0, y: 0.0, width: width.cgfloat, height: height.cgfloat))
            // You don't need the context at this point, so you need to release it to avoid memory leaks.
            // Use OpenGL ES to generate a name for the texture.
            glGenTextures(1, &texId)
            // Bind the texture name.
            glBindTexture(GL_TEXTURE_2D.gluint, texId)
            // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
            glTexParameteri(GL_TEXTURE_2D.gluint, GL_TEXTURE_MIN_FILTER.gluint, GL_LINEAR)
            // Specify a 2D texture image, providing the a pointer to the image data in memory
            glTexImage2D(GL_TEXTURE_2D.gluint, 0, GL_RGBA, width.int32, height.int32, 0, GL_RGBA.gluint, GL_UNSIGNED_BYTE.gluint, brushData)
            // Release  the image data; it's no longer needed

            self.id = texId
            self.width = width.int32
            self.height = height.int32
        }
    }
}
