//
//  SfRouterView.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 19.12.22.
//

import SwiftUI

public struct SfRouterView<V: View, T: Hashable>: View {
    let router: SfRouter<T>
    let viewForRoute: (T) -> V

    public init(router: SfRouter<T>, @ViewBuilder viewForRoute: @escaping (T) -> V) {
        self.router = router
        self.viewForRoute = viewForRoute
    }

    public var body: some View {
        Group {
            if #available(iOS 16, *) {
                SfRouterStackView(router: router, viewForRoute: viewForRoute)
            } else {
                SfNavigationNode(router: router, viewForRoute: viewForRoute)
            }
        }
        .environmentObject(router)
    }
}
