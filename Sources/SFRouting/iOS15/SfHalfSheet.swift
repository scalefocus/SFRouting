//
//  SfHalfSheet.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 12/01/2023.
//

import SwiftUI
import UIKit

struct SfHalfSheet<Content>: UIViewControllerRepresentable where Content: View {
    private let content: Content
    private let detents: [UISheetPresentationController.Detent]
    private let prefersGrabberVisible: Bool

    init(
        detents: [UISheetPresentationController.Detent] = [.medium()],
        prefersGrabberVisible: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.detents = detents
        self.prefersGrabberVisible = prefersGrabberVisible
        self.content = content()
    }

    func makeUIViewController(context: Context) -> SfHalfSheetController<Content> {
        return SfHalfSheetController(rootView: content)
    }

    func updateUIViewController(_ controller: SfHalfSheetController<Content>, context: Context) {
        controller.detents = detents
        controller.prefersGrabberVisible = prefersGrabberVisible
    }
}

final class SfHalfSheetController<Content>: UIHostingController<Content> where Content: View {
    var detents: [UISheetPresentationController.Detent] = []
    var prefersGrabberVisible: Bool = false
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let presentation = sheetPresentationController {
            presentation.detents = detents
            presentation.prefersGrabberVisible = prefersGrabberVisible
            presentation.preferredCornerRadius = 16
            presentation.largestUndimmedDetentIdentifier = .none
        }
    }
}
