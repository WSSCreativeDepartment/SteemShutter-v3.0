//
//  cameraView.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 19/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit
import AVFoundation

class cameraView: UIViewController {
    
    // Buttons for camera
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    
    @IBOutlet weak var shutterButton: UIButton!
    
    // cameraPreviewOutlet
    
    @IBOutlet weak var cameraPreview: UIView!
    
    
    // Gestures
    
    @IBOutlet var focusTapGesture: UITapGestureRecognizer!
    var zoomInGesture = UISwipeGestureRecognizer()
    var zoomOutGesture = UISwipeGestureRecognizer()
    
    // Functions
    
    var captureSession = AVCaptureSession()
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    // Device
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var flashMode = AVCaptureDevice.FlashMode.off
    
    
    // image to send to photoEdit
    var image: UIImage?
    
    
    
    
    var focusPoint: CGPoint?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calling the functions
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        zoomInGesture.direction = .right
        zoomInGesture.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGesture)
        
        zoomOutGesture.direction = .left
        zoomOutGesture.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGesture)

    }
    
    // I am still working on autorotation
    
    override func viewDidLayoutSubviews() {
        cameraPreview?.frame = cameraPreview.bounds
        if let photoImage = cameraPreviewLayer ,(photoImage.connection?.isVideoOrientationSupported)! {
            photoImage.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation!
        }
    }
    
    // Capture session, Front device, back device, photo output an preview layer
    
    func setupCaptureSession()  {
        captureSession.sessionPreset = AVCaptureSession.Preset .photo
    }
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.frame = cameraPreview.bounds
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreview.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
        
        
    }
    
    
    // swipe from left to right to zoom in. Swipe from right to left to zoom out
    
    @objc func zoomIn() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // Tap to change autofocus mode to manual focus mode. I am still working on the focus 'aim"

    @IBAction func focusAction(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            let thisFocusPoint = sender.location(in: cameraPreview)
            
            print("touch to focus ", thisFocusPoint)
            
            
            let focus_x = thisFocusPoint.x / cameraPreview.frame.size.width
            let focus_y = thisFocusPoint.y / cameraPreview.frame.size.height
            
            
            
            
            
            
            if (currentCamera!.isFocusModeSupported(.autoFocus) && currentCamera!.isFocusPointOfInterestSupported) {
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.focusMode = .autoFocus
                    currentCamera?.focusPointOfInterest = CGPoint(x: focus_x, y: focus_y)
                    
                    if (currentCamera!.isExposureModeSupported(.autoExpose) && currentCamera!.isExposurePointOfInterestSupported) {
                        currentCamera?.exposureMode = .autoExpose;
                        currentCamera?.exposurePointOfInterest = CGPoint(x: focus_x, y: focus_y);
                    }
                    
                    
                    
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    @IBAction func flashButtonAction(_ sender: Any) {
        // Flash on/flash off
        
        if flashMode == .on {
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "unnamed-4"), for: .normal)
        }
        else {
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "superlood"), for: .normal)
        }
        
    }
    
    
    
    // Front to back / back to front
    
    @IBAction func rotateCameraAction(_ sender: Any) {
        captureSession.beginConfiguration()
        let awesomeDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
            let cameraInput:AVCaptureDeviceInput
            do {
                cameraInput = try AVCaptureDeviceInput(device: awesomeDevice!)
            } catch {
                print(error)
                return
            }
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
            
            currentCamera = awesomeDevice
            captureSession.commitConfiguration()
        }
    }
    
    @IBAction func shutterAction(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // This is a preparaion for a segue that brings a photo image and signature text with font to Preview Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoEditSegue" {
            let previewViewController = segue.destination as! photoEdit
            previewViewController.image = self.image
        
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}
extension cameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation()
            
        {
            self.image = UIImage(data: imageData)
            image = image?.fixOrientation()
            performSegue(withIdentifier: "photoEditSegue", sender: nil)
        }
    }
}

// this is what I need for my next update. I am working on device's autorotation
extension UIImage {
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImageOrientation.left ||
            
            
            self.imageOrientation == UIImageOrientation.leftMirrored ||
            self.imageOrientation == UIImageOrientation.right ||
            self.imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
