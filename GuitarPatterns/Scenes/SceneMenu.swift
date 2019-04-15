//
//  SceneMenu.swift
//  GuitarPatterns
//
//  Created by Alberto Banet Masa on 20/3/19.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import SpriteKit


/**
 Clase encargada de generar un menú que permite elegir entre diferentes patrones
*/
class SceneMenu: SKScene {
    var patronSeleccionado: Int? // posición del patrón seleccionado
    
    let menu = SKNode()
    var startLocationX: CGFloat = 0.0
    var maxPosXMenu: CGFloat = 0.0
    var moviendo: Bool = false
    var filtro: TipoPatron? // tipo de patrones a mostrar. Por defecto todos (nil)
    var privada: Bool = false // estamos trabajando con patrones publicos o privados?
    
    var lblNombrePatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "Nexa-Bold"
        return label
    }()
    var lblDescripcionPatron: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "NexaBook"
        return label
    }()
    var lblNumPatrones: SKLabelNode = {
        let label = SKLabelNode()
        label.fontSize = 18.0
        label.fontName = "NexaBook"
        label.text = "0"
        return label
    }()
    

    var btnDelete: UIButton = Boton.crearBoton(nombre: "Eliminar".localizada())
    var btnEditar: UIButton = Boton.crearBoton(nombre: "Editar Patron".localizada())
    var btnNuevo: UIButton = Boton.crearBoton(nombre: "Nuevo".localizada())
    var btnVolver: UIButton = Boton.crearBoton(nombre: "Volver".localizada())
    var btnAdd: UIButton = Boton.crearBoton(nombre: "Añadir".localizada())
    var btnJugar: UIButton = Boton.crearBoton(nombre: "Jugar".localizada())
  
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Colores.background
        crearMenuGrafico()
      if privada {
        addUserInterfaz(botones: [btnVolver, btnEditar, btnDelete, btnNuevo, btnJugar])
      } else {
        addUserInterfaz(botones: [btnVolver, btnAdd, btnJugar])
      }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let locationMenu = touch.location(in: menu)
            if menu.contains(location) {
                moviendo = true
                startLocationX = menu.position.x - location.x
                print(menu.nodes(at:locationMenu).first?.name)
                if menu.nodes(at:locationMenu).first?.name == "zonatactil" {
                    if let nodo = menu.nodes(at:locationMenu).first?.parent as? GuitarraStatica,
                        let indicePatronElegido = Int(nodo.name!) {
                        actualizarDatosPatron(indice: indicePatronElegido - 1)
                        patronSeleccionado = indicePatronElegido - 1
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moviendo {
            let location = touch.location(in: self)
            menu.position.x = location.x + startLocationX
            // vigilamos que el menú no desborde la pantalla por la izquierda
            if menu.position.x > 0 {
                menu.position.x = 0
            }
            // vigilamos que el menú no desborde la pantalla por la derecha
            if menu.position.x < -maxPosXMenu + size.width {
                menu.position.x = -maxPosXMenu + size.width
            }
        }
    }
    
    private func crearMenuGrafico() {
        if privada {
            PatronesDB.share.getPatronesPrivada { [unowned self] patrones in
                self.crearMenuGrafico(conPatrones: patrones)
            }
        } else {
            PatronesDB.share.getPatronesPublica { [unowned self] patrones in
                if let filtro = self.filtro {
                    let patronesFiltrados = patrones.filter {patron in patron.getTipo() == filtro}
                    self.crearMenuGrafico(conPatrones: patronesFiltrados)
                } else {
                    self.crearMenuGrafico(conPatrones: patrones)
                }
            }
        }
    }
    
    private func crearMenuGrafico(conPatrones patrones: [Patron]) {
        eliminarMenu() // Antes de crear el menú eliminamos el que pudiera existir
        var x: CGFloat = 0.0
        if patrones.count > 0 {
            for n in 1...patrones.count {
                let nuevoPatron = GuitarraStatica(size: CGSize(width: self.size.width/2.2, height: self.size.height/2.2))
                nuevoPatron.name = "\(n)"
                nuevoPatron.dibujarPatron(patrones[n-1])
                nuevoPatron.isUserInteractionEnabled = false
                nuevoPatron.position = CGPoint(x: x, y: 0)
                x += self.size.width/2.5// + self.size.width/25 // dejamos un espacio extra de margen
                self.menu.addChild(nuevoPatron)
                
            }
            self.maxPosXMenu = x
            self.addChild(self.menu)
            self.menu.name = "menu"
            self.menu.position.y = Medidas.bottomSpace
        }
    }
    
    private func eliminarMenu() {
        menu.removeAllChildren()
        menu.removeFromParent()
    }
    
  private func addUserInterfaz(botones:[UIButton]) {
    // Cálculo de dimensiones y posiciones para n botones
    let numBotones = CGFloat(botones.count)
    let maxAnchoBoton = self.view!.frame.width / numBotones
    let totalEspacioEntreBotones = Medidas.minimumMargin * numBotones
    let anchoBoton: CGFloat = maxAnchoBoton - totalEspacioEntreBotones - (Medidas.minimumMargin * (numBotones - 1))
    let totalEspacioBotones = numBotones * anchoBoton
    let posLeading: CGFloat = (self.view!.frame.width - totalEspacioBotones - totalEspacioEntreBotones) / 2
    
    // Añadir los botones a la vista principal
    for boton in botones {
      self.view?.addSubview(boton)
    }
    // Posicionar botones
    for (indice, boton) in botones.enumerated() {
      boton.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: Medidas.minimumMargin * 3).isActive = true
      boton.widthAnchor.constraint(equalToConstant: anchoBoton).isActive = true
      if indice == 0 {
         boton.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: posLeading).isActive = true
      } else {
         boton.leadingAnchor.constraint(equalTo: botones[indice-1].trailingAnchor, constant: Medidas.minimumMargin).isActive = true
      }
    }
    
    
    // Asociamos acciones
    btnDelete.addTarget(self, action: #selector(btnDeletePulsado), for: .touchDown)
    btnEditar.addTarget(self, action: #selector(btnEditarPulsado), for: .touchDown)
    btnNuevo.addTarget(self, action: #selector(btnNuevoPulsado), for: .touchDown)
    btnVolver.addTarget(self, action: #selector(btnVolverPulsado), for: .touchDown)
    btnAdd.addTarget(self, action: #selector(btnAddPulsado), for: .touchDown)
    btnJugar.addTarget(self, action: #selector(btnJugarPulsado), for: .touchDown)
    
    // Añadimos etiquetas
    addChild(lblNumPatrones)
    addChild(lblNombrePatron)
    addChild(lblDescripcionPatron)
    
    lblNombrePatron.position = CGPoint(x: self.view!.frame.width/2, y: Medidas.bottomSpace + Medidas.minimumMargin)
    lblDescripcionPatron.position = CGPoint(x: self.view!.frame.width/2, y: lblNombrePatron.position.y - Medidas.minimumMargin * 3)
    
    resetDatosPatron()
  }
    
    private func resetDatosPatron() {
        lblNombrePatron.text = "Selecciona un patrón".localizada()
        lblDescripcionPatron.text = "y pulsa sobre la opción deseada del menú.".localizada()
    }
    
    /**
     Elimina el patrón seleccionado de la base de datos.
    */
    @objc func btnDeletePulsado() {
        if let indice = patronSeleccionado  {
            Alertas.mostrarOkCancel(titulo: "¡Atención!", mensaje: "El patrón seleccionado se borrará de su base de datos de patrones.", enViewController: view!.window!.rootViewController!) {
                [unowned self] alerta in
                // Eliminar registro de la base de datos
                if self.privada {
                    if let id = PatronesDB.share.cachePatronesPrivada[indice].getId() {
                        PatronesDB.share.eliminarRegistroPrivada(id: id)
                        self.crearMenuGrafico(conPatrones: PatronesDB.share.cachePatronesPrivada)
                        DispatchQueue.main.async {
                            self.resetDatosPatron()
                        }
                    }
                } else {
                if let id = PatronesDB.share.cachePatronesPublica[indice].getId() {
                    PatronesDB.share.eliminarRegistroPublica(id: id)
                    self.crearMenuGrafico(conPatrones: PatronesDB.share.cachePatronesPublica)
                    DispatchQueue.main.async {
                        self.resetDatosPatron()
                    }
                }
                }
            }
        }
      
    }
    
    /**
     Llama a la escena de edición con el patrón seleccionado
     */
    @objc func btnEditarPulsado() {
        if let indice = patronSeleccionado {
            if self.privada {
                irAPatron(PatronesDB.share.cachePatronesPrivada[indice])
            } else {
                irAPatron(PatronesDB.share.cachePatronesPublica[indice])
            }
        }
    }
    
    /**
     Va al editor de patrones para crear un nuevo patrón
     */
    @objc func btnNuevoPulsado() {
        irAPatron(nil)
    }
    
    /**
     Regresa a la pantalla del menú principal
     */
    @objc func btnVolverPulsado() {
        guard let vista = self.scene?.view else {
            return
        }
        vista.eliminarUIKit()
        removeAllChildren()
        
        let accion = SKAction.run {
            let escena = SceneMenuPrincipal(size: self.size)
            //vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([accion]))
    }
  
  /**
    Añade el botón a la base de datos privada del usuario
  */
  @objc func btnAddPulsado() {
    guard !privada else { return } // estamos en la pública con total seguridad.
    if let indice = patronSeleccionado { // existe un patrón seleccionado
      let patron = PatronesDB.share.cachePatronesPublica[indice]
      PatronesDB.share.grabarPatronEnPrivada(patron) {
        grabado in
        if grabado {
          DispatchQueue.main.async {
            Alertas.mostrar(titulo: "Patron Añadido".localizada(), mensaje: "El patrón seleccionado se ha añadido a la lista de tus patrones.".localizada(), enViewController: self.view!.window!.rootViewController!)
          }
        }
      }
    } else {
      Alertas.mostrar(titulo: "Selecciona un patrón".localizada(), mensaje: "Para poder añadir un patrón en tu sección 'Mis Patrones' tienes que tenerlo seleccionado".localizada(), enViewController: self.view!.window!.rootViewController!)
    }
  }
  
  /**
   Entra en la escena de juego para el patron seleccionado
   */
  @objc func btnJugarPulsado() {
    
  }
  
    
    private func actualizarDatosPatron(indice: Int) {
      if privada {
        lblNombrePatron.text = PatronesDB.share.cachePatronesPrivada[indice].getNombre()
        lblDescripcionPatron.text = PatronesDB.share.cachePatronesPrivada[indice].getDescripcion()
      } else {
        lblNombrePatron.text = PatronesDB.share.cachePatronesPublica[indice].getNombre()
        lblDescripcionPatron.text = PatronesDB.share.cachePatronesPublica[indice].getDescripcion()
      }
        for (index, opcion) in menu.children.enumerated() {
            if let opcion = opcion as? GuitarraStatica {
                if index == indice {
                    opcion.zonaTactil.fillColor = UIColor.orange.withAlphaComponent(0.3)
                } else {
                    opcion.zonaTactil.fillColor = .clear
                }
            }
        }
    }
    
    private func irAPatron(_ patron: Patron?) {
        guard let vista = self.scene?.view else {
            return
        }
        vista.eliminarUIKit()
        removeAllChildren()
        //let wait = SKAction.wait(forDuration: 2.0)
        let irPatronAction = SKAction.run {
            let escena = SceneEditor(size: self.size, patron: patron)
            escena.parentScene = self // para saber a que escena volver
            vista.ignoresSiblingOrder = true
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            vista.presentScene(escena, transition: reveal)
        }
        self.run(SKAction.sequence([irPatronAction]))//([wait, irJuegoPatron]))
    }
    
    
}
