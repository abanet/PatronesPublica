//
//  MenuPatron.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 9/4/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import SpriteKit


class MenuPatron: GuitarraView {
    var zonaTactil:SKShapeNode
    
     init(size: CGSize) {
        zonaTactil = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 50), size: size))
        zonaTactil.fillColor = .clear
        zonaTactil.isUserInteractionEnabled = false
        zonaTactil.zPosition  = 10
        zonaTactil.name = "zonatactil"
        
        super.init(size: size)
        
        deshabilitarGuitarra()
        addChild(zonaTactil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Patron tocado:\(self.name)")
    }
    
    private func deshabilitarGuitarra() {
        for child in self.children {
            child.isUserInteractionEnabled = false
        }
    }
}
