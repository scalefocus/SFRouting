//
//  SfRootNode.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 4.01.23.
//

import SwiftUI

struct SfRootNode<V: View, T: Hashable>: View {
    let router: SfRouter<T>
    @ObservedObject var pathInfo: SfPathInfo<T>
    let viewForRoute: (T) -> V

    var body: some View {
        NavigationView {
            viewForRoute(pathInfo.root)
            .background(
                SfNavigationLink(
                    router: router,
                    pathInfo: pathInfo,
                    index: 0,
                    viewForRoute: viewForRoute
                )
                .hidden()
            )
        }
        .navigationViewStyle(.stack)
    }
}
