//
//  testTraste.swift
//  GuitarPatternsTests
//
//  Created by Alberto Banet Masa on 13/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import XCTest
@testable import GuitarPatterns

class testTraste: XCTestCase {

    let trasteBlanco = Traste(cuerda: 6, traste: 1, estado: .blanco)
    let trasteIntervalo = Traste(cuerda: 5, traste: 2, estado: .intervalo(TipoIntervaloMusical(rawValue: "2b")!))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrasteBlanco() {
         XCTAssertTrue(trasteBlanco.estaBlanco())
         XCTAssertFalse(trasteIntervalo.estaBlanco())
    }



}