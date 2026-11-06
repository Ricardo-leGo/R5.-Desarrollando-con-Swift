//
//  ContentView.swift
//  R5 Desarrollando con Swift
//
//  Created by Ricardo Leyva on 05/11/26.
//

import SwiftUI

enum Personaje: String, CaseIterable {
    case elLider = "El Líder Estratégico"
    case elSabio = "El Sabio Analítico"
    case elAventurero = "El Aventurero Audaz"
    case elCreativo = "El Creativo Soñador"
    
    var descripcion: String {
        switch self {
        case .elLider:
            return "Eres una persona con visión, capacidad de mando y determinación para guiar a otros en momentos críticos."
        case .elSabio:
            return "Destacas por tu lógica, paciencia y amor por el conocimiento. Siempre analizas antes de actuar."
        case .elAventurero:
            return "Tu impulso es la acción y la adrenalina. No le temes al riesgo y siempre buscas nuevos desafíos."
        case .elCreativo:
            return "Posees una imaginación sin límites. Ves el mundo desde perspectivas únicas y resuelves problemas de forma innovadora."
        }
    }
}

struct Opcion {
    let texto: String
    let personajeAsociado: Personaje
}

struct Pregunta {
    let enunciado: String
    let opciones: [Opcion]
}

struct ContentView: View {
    let preguntas: [Pregunta] = [
        Pregunta(enunciado: "1. ¿Cómo reaccionas ante un problema inesperado?", opciones: [
            Opcion(texto: "Tomo el control y organizo al equipo.", personajeAsociado: .elLider),
            Opcion(texto: "Analizo todas las variables antes de moverme.", personajeAsociado: .elSabio),
            Opcion(texto: "Actúo de inmediato con lo que tenga a la mano.", personajeAsociado: .elAventurero),
            Opcion(texto: "Busco una solución fuera de lo convencional.", personajeAsociado: .elCreativo)
        ]),
        Pregunta(enunciado: "2. ¿Cuál es tu entorno ideal para pasar el fin de semana?", opciones: [
            Opcion(texto: "Dirigiendo un proyecto personal o evento.", personajeAsociado: .elLider),
            Opcion(texto: "Leyendo o aprendiendo algo nuevo en tranquilidad.", personajeAsociado: .elSabio),
            Opcion(texto: "Explorando la naturaleza o practicando deportes extremos.", personajeAsociado: .elAventurero),
            Opcion(texto: "Diseñando, escribiendo o creando arte.", personajeAsociado: .elCreativo)
        ]),
        Pregunta(enunciado: "3. ¿Qué cualidad valoras más en ti mismo?", opciones: [
            Opcion(texto: "La capacidad de inspirar a otros.", personajeAsociado: .elLider),
            Opcion(texto: "La claridad mental y el conocimiento.", personajeAsociado: .elSabio),
            Opcion(texto: "La valentía frente al peligro.", personajeAsociado: .elAventurero),
            Opcion(texto: "La originalidad de mis ideas.", personajeAsociado: .elCreativo)
        ]),
        Pregunta(enunciado: "4. Ante un desafío en equipo, ¿cuál es tu rol?", opciones: [
            Opcion(texto: "El coordinador que asigna responsabilidades.", personajeAsociado: .elLider),
            Opcion(texto: "El estratega que diseña el plan detallado.", personajeAsociado: .elSabio),
            Opcion(texto: "El ejecutor que va al frente sin dudar.", personajeAsociado: .elAventurero),
            Opcion(texto: "El generador de ideas e innovación.", personajeAsociado: .elCreativo)
        ]),
        Pregunta(enunciado: "5. ¿Cuál es tu mayor motivación en la vida?", opciones: [
            Opcion(texto: "Alcanzar el éxito y dejar un impacto duradero.", personajeAsociado: .elLider),
            Opcion(texto: "Comprender a fondo cómo funciona el mundo.", personajeAsociado: .elSabio),
            Opcion(texto: "Vivir experiencias intensas y memorables.", personajeAsociado: .elAventurero),
            Opcion(texto: "Expresar mi individualidad y visión única.", personajeAsociado: .elCreativo)
        ])
    ]
    
    @State private var indicePreguntaActual: Int = 0
    @State private var opcionSeleccionadaEnPreguntaActual: Int? = nil
    
    @State private var respuestasUsuario: [Int: Opcion] = [:]
    
    @State private var cuestionarioFinalizado: Bool = false
    @State private var personajeGanador: Personaje? = nil
    
    var body: some View {
        VStack {
            if !cuestionarioFinalizado {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Pregunta \(indicePreguntaActual + 1) de \(preguntas.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(preguntas[indicePreguntaActual].enunciado)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)
                    
                    ForEach(0..<preguntas[indicePreguntaActual].opciones.count, id: \.self) { indiceOpcion in
                        let opcion = preguntas[indicePreguntaActual].opciones[indiceOpcion]
                        
                        Button(action: {
                            // Permite cambiar o seleccionar otra opción libremente mientras esté en la pregunta
                            opcionSeleccionadaEnPreguntaActual = indiceOpcion
                            respuestasUsuario[indicePreguntaActual] = opcion
                        }) {
                            HStack {
                                Text(opcion.texto)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if opcionSeleccionadaEnPreguntaActual == indiceOpcion {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(opcionSeleccionadaEnPreguntaActual == indiceOpcion ? Color.green : Color.gray, lineWidth: 1.5)
                            )
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    if opcionSeleccionadaEnPreguntaActual != nil {
                        Button(action: avanzarSiguientePregunta) {
                            Text(indicePreguntaActual == preguntas.count - 1 ? "Ver Resultado" : "Siguiente Pregunta")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            } else {
                if let personaje = personajeGanador {
                    VStack(spacing: 20) {
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)
                        
                        Text("¡Tu personaje es!")
                            .font(.headline)
                        
                        Text(personaje.rawValue)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.blue)
                        
                        Text(personaje.descripcion)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: reiniciarCuestionario) {
                            Text("Reiniciar Cuestionario")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
   
    private func avanzarSiguientePregunta() {
        if indicePreguntaActual < preguntas.count - 1 {
            indicePreguntaActual += 1
            opcionSeleccionadaEnPreguntaActual = nil
        } else {
            calcularResultado()
            cuestionarioFinalizado = true
        }
    }
    
    private func calcularResultado() {
        var puntajes: [Personaje: Int] = [
            .elLider: 0,
            .elSabio: 0,
            .elAventurero: 0,
            .elCreativo: 0
        ]
        
        for (_, opcion) in respuestasUsuario {
            puntajes[opcion.personajeAsociado, default: 0] += 1
        }
        
        var maxPuntos = -1
        var ganador: Personaje = .elLider
        
        for (personaje, puntos) in puntajes {
            if puntos > maxPuntos {
                maxPuntos = puntos
                ganador = personaje
            }
        }
        
        self.personajeGanador = ganador
    }
    
    private func reiniciarCuestionario() {
        indicePreguntaActual = 0
        opcionSeleccionadaEnPreguntaActual = nil
        cuestionarioFinalizado = false
        personajeGanador = nil
        respuestasUsuario.removeAll()
    }
}

#Preview {
    ContentView()
}
