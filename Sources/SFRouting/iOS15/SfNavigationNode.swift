//
//  SfNavigationNode.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 4.01.23.
//

import SwiftUI

struct SfNavigationNode<V: View, T: Hashable>: View {
    let router: SfRouter<T>
    @ObservedObject var pathInfo: SfPathInfo<T>
    let viewForRoute: (T) -> V

    init(
        router: SfRouter<T>,
        pathInfo: SfPathInfo<T>? = nil,
        @ViewBuilder viewForRoute: @escaping (T) -> V
    ) {
        self.router = router
        self.pathInfo = pathInfo ?? router.pathInfo
        self.viewForRoute = viewForRoute
    }

    var body: some View {
        SfRootNode(router: router, pathInfo: pathInfo, viewForRoute: viewForRoute)
        .fullScreenCover(isPresented: Binding(
            get: { return pathInfo.showFullScreen },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            SfNavigationNode(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
        }
        .sheet(isPresented: Binding(
            get: { return pathInfo.showSheet },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            if pathInfo.isHalfSheet {
                SfHalfSheet {
                    SfNavigationNode(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
                }
            } else {
                SfNavigationNode(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
            }
        }
    }
}
