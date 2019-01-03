//
//  Mask.swift
//  Facial Exercises
//
//  Created by Vuk Radosavljevic on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import ARKit
import SceneKit

class Mask: SCNNode, VirtualFaceContent {
    
    init(geometry: ARSCNFaceGeometry) {
        super.init()
        let material = geometry.firstMaterial!
        material.diffuse.contents = UIColor.white
        
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    // MARK: VirtualFaceContent
    
    /// - Tag: SCNFaceGeometryUpdate
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        let faceGeometry = geometry as! ARSCNFaceGeometry
        faceGeometry.update(from: anchor.geometry)
    }
}

protocol VirtualFaceContent {
    func update(withFaceAnchor: ARFaceAnchor)
}

typealias VirtualFaceNode = VirtualFaceContent & SCNNode
