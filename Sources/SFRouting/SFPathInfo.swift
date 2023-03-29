//
//  SfPathInfo.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 4.01.23.
//

import Foundation
import SwiftUI

public enum SfPresentationMode {
    case stack
    case fullScreen
    case sheet
    case halfSheet
}

public class SfPathInfo<Т: Hashable>: ObservableObject {

    @Published public var root: Т
    @Published public var path: [Т] = []
    @Published public var presentationMode: SfPresentationMode = .stack
    @Published public var subPath: SfPathInfo?
    public weak var parent: SfPathInfo?

    public var showFullScreen: Bool {
        subPath != nil && subPath!.presentationMode == .fullScreen
    }

    public var showSheet: Bool {
        subPath != nil && (subPath!.presentationMode == .sheet || isHalfSheet)
    }

    public var isHalfSheet: Bool {
        subPath != nil && subPath!.presentationMode == .halfSheet
    }

    @available(iOS 16.0, *)
    public var detents: Set<PresentationDetent> {
        guard showSheet else { return [] }
        if subPath!.presentationMode == .halfSheet {
            return [.medium]
        } else {
            return [.large]
        }
    }

    public init(
        root: Т,
        presentationMode: SfPresentationMode = .stack,
        parent: SfPathInfo? = nil
    ) {
        self.root = root
        self.presentationMode = presentationMode
        self.parent = parent
    }
}
