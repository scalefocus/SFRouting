//
//  SfNode.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 4.01.23.
//

import SwiftUI

struct SfNode<V: View, T: Hashable>: View {
    let router: SfRouter<T>
    @ObservedObject var pathInfo: SfPathInfo<T>
    let index: Int
    let viewForRoute: (T) -> V
    var cachedRoute: T?

    init(
        router: SfRouter<T>,
        pathInfo: SfPathInfo<T>,
        index: Int,
        @ViewBuilder viewForRoute: @escaping (T) -> V
    ) {
        self.router = router
        self.pathInfo = pathInfo
        self.index = index
        self.viewForRoute = viewForRoute
        if index < pathInfo.path.count {
            self.cachedRoute = pathInfo.path[index]
        }
    }

    var body: some View {
        if index > pathInfo.path.count-1 {
            Group {
                if cachedRoute != nil {
                    viewForRoute(cachedRoute!)
                }
            }
        } else {
            viewForRoute(pathInfo.path[index])
            .background(
                SfNavigationLink(
                    router: router,
                    pathInfo: pathInfo,
                    index: index+1,
                    viewForRoute: viewForRoute
                )
                .hidden()
            )
        }
    }
}
