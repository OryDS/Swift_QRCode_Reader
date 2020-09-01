//
//  ViewController.swift
//  Qr_Code_Reader
//
//  Created by Orazio Conte on 25/08/2020.
//  Copyright © 2020 Orazio Conte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //    Viewfinder image
    @IBOutlet var square: UIImageView!
    
    //    Video capture preview
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Creating session
        let session = AVCaptureSession()
        
        //        Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        
        //        Input capture
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        //        Output define
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        //        Get the output on the main thread - (Best performance results)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //        define the metadata type
        output.metadataObjectTypes = [.qr]
        
        //        Merge the session to the Video Capture Preview
        video = AVCaptureVideoPreviewLayer(session: session)
        
        //        Set the frames -
        video.frame = view.layer.bounds
        
        //        Add video layer to full screen
        view.layer.addSublayer(video)
        
        //        Add a sublevel - (My image 'square')
        self.view.bringSubviewToFront(square)
        
        session.startRunning()
        
        
    }
    
    //    Output processing
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //        Check the array contents
        if metadataObjects.count != 0
        {
            //            Calls the object's position in the array
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                //                Assign a string value to the object
                let nameText = object.stringValue
                
                //                Check if the object is QR type
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    
                    //                    Get the QR content in an alert
                    let alert = UIAlertController(title: "The QR Code Contains:", message: "\(nameText!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

