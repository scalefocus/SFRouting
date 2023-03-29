//
//  SFNavigationLink.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 4.01.23.
//

import SwiftUI

struct SfNavigationLink<V: View, T: Hashable>: View {
    let router: SfRouter<T>
    @ObservedObject var pathInfo: SfPathInfo<T>
    let index: Int
    let viewForRoute: (T) -> V

    var body: some View {
        NavigationLink(
            destination: SfNode(
                router: router,
                pathInfo: pathInfo,
                index: index,
                viewForRoute: viewForRoute
            ),
            isActive: Binding<Bool>(
                get: {
                    return pathInfo.path.count > index
                },
                set: { newValue, _ in
                    if newValue == false && pathInfo.path.count > index {
                        router.pop()
                    }
                }
            )
        ) { EmptyView() }
    }
}
