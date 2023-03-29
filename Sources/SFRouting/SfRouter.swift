//
//  SfRouter.swift
//  SFRouter
//
//  Created by tsvetan.raykov on 15.11.22.
//

import Foundation

/// Implements basic routing functionality.
/// Together with VBRouterView provides dynamic navigation in your application.
///
public class SfRouter<Т: Hashable>: ObservableObject {
    @Published var pathInfo: SfPathInfo<Т>
    private weak var topPathInfo: SfPathInfo<Т>?

    public var currentRoute: Т {
        let info: SfPathInfo = topPathInfo ?? pathInfo
        if info.path.count > 0 {
            return info.path.last!
        }
        return info.root
    }

    /// Initialises a new router
    ///
    /// - Parameters:
    ///   - root: The initial route
    ///
    public init(_ root: Т) {
        self.pathInfo = SfPathInfo(root: root)
        self.topPathInfo = self.pathInfo
    }

    /// A method used to push a new route to the stack
    ///
    /// - Parameters:
    ///   - route: the route to append
    ///   - presentationMode: Defines the presentation mode. It can be one of the following:
    ///     - stack - this is the default option, presents the route as in NavigationStack
    ///     - sheet - presents the route in a sheet
    ///     - fullScreen - uses fullScreenCover to present the route
    ///
    public func push(_ route: Т, presentationMode: SfPresentationMode = .stack) {
        DispatchQueue.main.async {
            if presentationMode == .stack {
                self.topPathInfo?.path.append(route)
            } else {
                let newPathInfo = SfPathInfo(
                    root: route,
                    presentationMode: presentationMode,
                    parent: self.topPathInfo
                )
                self.topPathInfo?.subPath = newPathInfo
                self.topPathInfo = newPathInfo
            }
        }
    }

    /// Pops the top route from the stack
    ///
    public func pop() {
        DispatchQueue.main.async {
            if self.topPathInfo != nil && self.topPathInfo!.path.count > 0 {
                self.topPathInfo?.path.removeLast()
            } else if self.topPathInfo?.parent != nil {
                self.topPathInfo = self.topPathInfo?.parent
                self.topPathInfo?.subPath = nil
            }
        }
    }

    /// Removes all routes from the stack and leaves only the root route.
    ///
    public func popToRoot() {
        DispatchQueue.main.async {
            if self.topPathInfo?.parent != nil {
                self.topPathInfo = self.topPathInfo?.parent
            }
            self.topPathInfo?.path = []
            self.topPathInfo?.subPath = nil
        }
    }

    /// Replaces the current path with a new root route.
    ///
    /// - Parameters:
    ///   - route: the new route to be used as root one
    ///
    public func replaceRoot(_ route: Т, path: [Т] = []) {
        DispatchQueue.main.async {
            self.pathInfo.root = route
            self.pathInfo.path = path
            self.pathInfo.subPath = nil
            self.topPathInfo = self.pathInfo
        }
    }

    /// This method removes all routes on top of the specified route, if it is contained in the stack.
    /// If the route is not on the stack, it does nothing.
    ///
    public func popTo(_ route: Т) {
        DispatchQueue.main.async {
            if self.topPathInfo != nil, let index = self.topPathInfo?.path.firstIndex(of: route) {
                let pathsToRemove = self.topPathInfo!.path.count - (index + 1)
                self.topPathInfo?.path.removeLast(pathsToRemove)
            } else if self.topPathInfo?.root == route {
                self.topPathInfo?.path = []
            }
        }
    }

    /// If the route in on the stack, this method pops to it. If it is not, it pushes the route on top of the stack.
    ///
    public func goTo(_ route: Т) {
        DispatchQueue.main.async {
            if self.topPathInfo != nil, let index = self.topPathInfo?.path.firstIndex(of: route) {
                let pathsToRemove = self.topPathInfo!.path.count - (index + 1)
                self.topPathInfo?.path.removeLast(pathsToRemove)
            } else if self.topPathInfo?.root == route {
                self.topPathInfo?.path = []
            } else {
                self.topPathInfo?.path.append(route)
            }
        }
    }

    /// This method is used internally by the VBRouterView class
    ///
    func popTo(_ pathInfo: SfPathInfo<Т>) {
        DispatchQueue.main.async {
            var current = self.topPathInfo
            while current != nil {
                if current === pathInfo {
                    self.topPathInfo = current
                    self.topPathInfo?.subPath = nil
                    return
                }
                current = current?.parent
            }
        }
    }
}
