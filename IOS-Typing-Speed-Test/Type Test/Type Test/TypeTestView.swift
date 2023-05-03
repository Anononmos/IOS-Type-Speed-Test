//
//  ContentView.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-04.
//

import SwiftUI
import UIKit

struct TypeTestView: View {
    
    @State private var text = ""
    @State private var sample = SampleText()
    
    @StateObject private var manager = TypeManager()
    @StateObject private var timer = StopWatchManager()
    
    private let background = Color(UIColor(named: "Background")!)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                background.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section {
                        Sample(text: $text, manager: manager, timer: timer, sample: $sample)
                        TestTimer(timer: timer, sample: sample)
                    }
                    .minimumScaleFactor(0.5)
                    
                    Section (header: Text("Type Below")
                                .bold()
                                .foregroundColor(.blue)
                    ) {
                        Editor(manager: manager, timer: timer, letters: text.asLetterArray())
                    }
                }
                .navigationBarTitle("Typing Speed Test")
            }
        }
    }
}

struct TestTimer: View {
    
    @ObservedObject var timer: StopWatchManager
    let sample: SampleText
    
    var body: some View {
        VStack {
            
            if timer.mode == .paused {
                let rate = String(format: "%.0f", timer.calculateRate(sample.wordCount))
            
                Text("\(timer.timeString) You type \(rate) words per minute.")
                    .font(.headline)
                    .padding()
            }
            
            else {
                Text(timer.timeString)
                    .bold()
                    .font(.title2)
                    .padding()
            }
        }
    }
}

struct Sample: View {
    
    @Binding var text: String
    @ObservedObject var manager: TypeManager
    @ObservedObject var timer: StopWatchManager
    @Binding var sample: SampleText
    
    var body: some View {
        
        StyledText(verbatim: text)
            .style(.highlight(.green), ranges: { $0.ranges(corrections: manager.corrections) })
            .style(.highlight(.red), ranges: { $0.ranges({ !$0 }, corrections: manager.corrections) })
            
            .font(.title3)
            .multilineTextAlignment(.leading)
            .padding()
            
            .onAppear {
                do {
                    if let text = try sample.getSentence(line: manager.line) {
                        self.text = text
                        manager.text = text
                    }
                    
                } catch {
                    text = error.localizedDescription
                    manager.text = ""
                }
            }
            .onChange(of: manager.line, perform: { _ in
                
                if let text = try! sample.getSentence(line: manager.line) {
                    self.text = text
                    manager.text = text
                    
                } else {
                    text = "Retake Test?"
                    manager.text = ""
                    
                    if timer.mode == .running {
                        timer.pause()
                        hideKeyboard()
                    }
                }
            })
            .modifier(Reset(
                        text: $text, sample: $sample, timer: timer, manager: manager
            ))
    }
}

struct Reset: ViewModifier {
    
    @Binding var text: String
    @Binding var sample: SampleText
    
    @ObservedObject var timer: StopWatchManager
    @ObservedObject var manager: TypeManager
    
    func body(content: Content) -> some View {
        if timer.mode == .paused {
            Button(action: {
                reset()
            },
            label: {
                content
            })
        }
        else {
            content
        }
    }
    
    func reset() {
        timer.stop()
        manager.line = 0
        sample = SampleText()
        
        do {
            if let text = try sample.getSentence(line: manager.line) {
                self.text = text
                manager.text = text
            }
            
        } catch {
            text = error.localizedDescription
            manager.text = ""
        }
    }
}

struct Editor: View {
    
    @ObservedObject var manager: TypeManager
    @ObservedObject var timer: StopWatchManager
    
    let letters: [String]
    
    var body: some View {

        TextField("Tap to Start: Press Return to Exit", text: $manager.typed)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            
            .padding()
            
            .onTapGesture {
                if timer.mode == .stopped {
                    timer.start()
                }
                
            }
            .onChange(of: manager.typed, perform: { value in
                
                guard value.last != nil else {
                    manager.resetIndex()
                    return
                }
                
                let i = manager.index
                
                if letters[i] == String(value.last!) {
                    manager.corrections[i] = true
                    
                } else {
                    manager.errorCount += 1
                    manager.corrections[i] = false
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TypeTestView()
    }
}
