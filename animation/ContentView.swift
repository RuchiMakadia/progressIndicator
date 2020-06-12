//
//  ContentView.swift
//  animation
//
//  Created by eheuristic on 12/06/20.
//  Copyright © 2020 ehs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var inc: CGFloat = 0.1
    var body: some View {
        VStack(alignment: .center) {
//            Button("Increase Progress") {
//                self.inc += 0.1
//            }
            ProgressIndicator(progress: $inc)
            //ProgressView(progress: $inc)
        }
//        .padding(.leading, 32)
//        .padding(.trailing, 32)
        
    }
}

struct ProgressIndicator: View {
    @Binding var progress: CGFloat
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero

    let balloon = Path { p in
        p.move(to: CGPoint(x: 20, y: 0))
        p.addQuadCurve(to: CGPoint(x: 0, y: 20),
                       control: CGPoint(x: 0, y: 0))
        p.addCurve(to: CGPoint(x: 20, y: 60),
                   control1: CGPoint(x: 0, y: 40),
                   control2: CGPoint(x: 20, y: 40))
        p.addCurve(to: CGPoint(x: 40, y: 20),
                   control1: CGPoint(x: 20, y: 40),
                   control2: CGPoint(x: 40, y: 40))
        p.addQuadCurve(to: CGPoint(x: 20, y: 0),
                       control: CGPoint(x: 40, y: 0))
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack {
                    Fit(path: self.balloon)
                        .foregroundColor(Color.blue)
                        .opacity(0.3)
                        .frame(width: 40, height: 60, alignment: .leading)
                        .padding(.bottom, -12)
                    
                    Text(String(format: "%.0f %%", ((self.position.width) * 100)/(geometry.size.width - 40)))
                        .font(.system(size: 14))
                }
                .gesture(
                     DragGesture()
                    .onChanged({ (value) in
                        if String(format: "%.0f %%", ((self.position.width) * 100)/(geometry.size.width - 40)) == "100 %" {
                            self.position.width = geometry.size.width - 40
                        }
                        else {
                            self.position.width += value.location.x
                        }
                    })
                        .onEnded({ (value) in
                          if String(format: "%.0f %%", ((self.position.width) * 100)/(geometry.size.width - 40)) == "100 %" {
                              self.position.width = geometry.size.width - 40
                          }
                    })
                )
                .offset(x: self.position.width - 20, y: 0)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width - 40, height: 30, alignment: .leading)
                        .cornerRadius(5)
                        .opacity(0.3)
                        .foregroundColor(Color.blue)
                    
                    Rectangle()
                        .frame(width: (((self.position.width * 100)/(geometry.size.width - 40)) * (geometry.size.width - 40))/100, height: 30, alignment: .leading)
                        .cornerRadius(5)
                        .conditionalView(((self.position.width) * 100)/(geometry.size.width - 40))
                }
            }
        }
    }
}

struct Fit: Shape {
    let path: Path
    func path(in rect: CGRect)-> Path {
        let bound = path.boundingRect
        return path.applying(CGAffineTransform(scaleX: rect.size.width/bound.size.width, y: rect.size.height/bound.size.height))
    }
}

struct ProgressView: View {
    @Binding var progress: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
                
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .conditionalView(self.progress)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}

extension View {
    func conditionalView(_ value: CGFloat) -> some View {
        self.modifier(ConditionalModifier(isProgress: value))
  }
}

struct ConditionalModifier: ViewModifier {
    var isProgress: CGFloat
    func body(content: Content) -> some View {
     Group {
        if self.isProgress > 66 {
            content.foregroundColor(Color.green)
        }
        else if self.isProgress > 33 {
            content.foregroundColor(Color.yellow)
        }
        else {
            content.foregroundColor(Color.red)
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
