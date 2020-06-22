//
//  ContentView.swift
//  animation
//
//  Created by eheuristic on 12/06/20.
//  Copyright © 2020 ehs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
            ProgressIndicator()
             .background(Color(UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1.00)))
            Spacer()
        }
        .background(Color(UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1.00)))
    }
}

struct ProgressIndicator: View {
    @State private var position = CGSize.zero
    @State private var animationAmount: CGFloat = 1

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
                        .foregroundColor(Color(UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1.00)))
                        .frame(width: 40, height: 60, alignment: .leading)
                         .shadow(color: Color.black.opacity(0.2), radius: 0, x: 2, y: 2)
                         .shadow(color: Color.white.opacity(0.7), radius: 0, x: -2, y: -2)
                        
                        .padding(.bottom, -8)
                        .scaleEffect(self.animationAmount)
                        .animation(.easeOut)
                      
                    
                    Text(String(format: "%.0f %%", ((self.position.width) * 100)/(geometry.size.width - 40)))
                        .font(.system(size: 12))
                    .animation(.easeOut)
                        
                }
                .gesture(
                     DragGesture()
                    .onChanged({ (value) in
                        self.position.width = min(self.position.width + value.location.x, geometry.size.width - 40)
                        self.animationAmount = 1.15
                    })
                        .onEnded({ (value) in
                            self.animationAmount = 1
                        })
                )
                .offset(x: self.position.width - 20, y: 0)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width - 40, height: 30, alignment: .leading)
                        .cornerRadius(5)
                        .foregroundColor(Color(UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1.00)))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
                     
                    Rectangle()
                        .frame(width: (((self.position.width * 100)/(geometry.size.width - 40)) * (geometry.size.width - 40))/100, height: 30, alignment: .leading)
                        .cornerRadius(5)
                        .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)
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
