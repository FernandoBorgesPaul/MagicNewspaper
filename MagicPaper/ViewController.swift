//
//  ViewController.swift
//  MagicPaper
//
//  Created by Fernando Borges Paul on 29/08/19.
//  Copyright © 2019 Fernando Borges Paul. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration to track images.
        let configuration = ARImageTrackingConfiguration()
        
        if  let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewPaperImages", bundle: Bundle.main) {
            
            configuration.trackingImages = trackedImages  // This will track the images from our Folder NewPaperImages
            
            configuration.maximumNumberOfTrackedImages = 1 // Configures the numbers of pictures it will track, in this case,1.
            
            
            
            print("Images found!")
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    //This method generates the rectangle that will anchor the image taht we want to capture. Rendering this, we can detect
    // the rectagle space from pour picture.
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let videoNode = SKVideoNode(fileNamed: "g7amazon.mp4")  // This video Node will be initialized using the
                                                                    // actual video from our bundle
            
            videoNode.play()  // Will play the video automatically
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            // The video will take the actual center position from the video Scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            videoNode.yScale = -1.0 // It will reverse the image to make it flip in the y axis.
            
            videoScene.addChild(videoNode)
            
            // This plane will get the same measure as the actual size from the physical picture
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height:   imageAnchor.referenceImage.physicalSize.height)
            
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            //The plane node will get the rectagle figure
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
  
        }
        
        return node
    }

}
