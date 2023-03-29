//
//  SfRouterStackView.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 19.12.22.
//

import SwiftUI

@available(iOS 16.0, *)
struct SfRouterStackView<V: View, T: Hashable>: View {
    @ObservedObject var pathInfo: SfPathInfo<T>
    let router: SfRouter<T>
    let viewForRoute: (T) -> V

    init(router: SfRouter<T>, pathInfo: SfPathInfo<T>? = nil, @ViewBuilder viewForRoute: @escaping (T) -> V) {
        self.router = router
        self.pathInfo = pathInfo ?? router.pathInfo
        self.viewForRoute = viewForRoute
    }

    var body: some View {
        NavigationStack(path: $pathInfo.path) {
            viewForRoute(pathInfo.root)
            .navigationDestination(for: T.self) { route in
                viewForRoute(route)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { return pathInfo.showFullScreen },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            SfRouterStackView(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
        }
        .sheet(isPresented: Binding(
            get: { return pathInfo.showSheet },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            SfRouterStackView(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
                .presentationDetents(pathInfo.detents)
        }
    }
}
