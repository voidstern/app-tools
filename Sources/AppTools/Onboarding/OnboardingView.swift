//
//  OnboardingView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 28.03.24.
//

import Foundation
import SwiftUI

public struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @State var currentStep: OnboardingStep?
    @State var navigaitonPath: NavigationPath
    
    let stepsBuilder: () -> [OnboardingStep]
    
    public init(@ArrayBuilder<OnboardingStep> _ builder: @escaping () -> [OnboardingStep]) {
        self.stepsBuilder = builder
        
        let firstStep = stepsBuilder().first
        
        _currentStep = State(initialValue: firstStep)
        _navigaitonPath = State(initialValue: NavigationPath())
    }
    
    public var body: some View {
        content
            .interactiveDismissDisabled()
            .onAppear { trackOnboardingStep(firstStep()) }
    }
    
    public var content: some View {
#if os(macOS)
        onboardingView(for: currentStep)
#else
        NavigationStack(path: $navigaitonPath) {
            onboardingView(for: firstStep())
                .navigationDestination(for: OnboardingStep.self) { step in
                    onboardingView(for: step)
                        .navigationBarBackButtonHidden()
                }
        }
#endif
    }
    
    private func onboardingView(for step: OnboardingStep?) -> AnyView {
        if let step{
            var view = step.viewBuilder()
            view.nextOnboardingStep = showNextStep
            return AnyView(view)
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func step(for stepIdentifier: String) -> OnboardingStep? {
        return stepsBuilder().filter({ $0.identifier == stepIdentifier }).first
    }
    
    private func firstStep() -> OnboardingStep? {
        return stepsBuilder().first
    }
    
    private func nextStep() -> OnboardingStep? {
        let steps = stepsBuilder()
        
        guard let currentStep else {
            return steps.first
        }
        
        guard let currentIndex = steps.firstIndex(of: currentStep) else {
            return nil
        }
        
        return steps.objectOrNil(at: currentIndex + 1)
    }
    
    private func showNextStep() {
        if let nextStep = nextStep() {
            trackOnboardingStep(nextStep)
            
            withAnimation {
                currentStep = nextStep
                navigaitonPath.append(nextStep)
            }
        } else {
            dismiss()
        }
    }
    
    private func trackOnboardingStep(_ step: OnboardingStep?) {
        guard let identifier = step?.identifier else {
            return
        }
        
        EventLogger.shared.log(event: .onboardingStep, parameters: ["step": identifier])
    }
}

public struct OnboardingStep: Hashable {
    let identifier: String
    let viewBuilder: (() -> any OnboardingSequenceView)
    
    public init(identifier: String, viewBuilder: @escaping () -> any OnboardingSequenceView) {
        self.identifier = identifier
        self.viewBuilder = viewBuilder
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public protocol OnboardingSequenceView: View {
    @MainActor
    var nextOnboardingStep: (() -> ())? { get set }
}
