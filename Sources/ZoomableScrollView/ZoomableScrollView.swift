// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

fileprivate let maxAllowedScale = 4.0

public struct ZoomableScrollView<ScollContent: View>: UIViewRepresentable {
    
    private var content: ScollContent
    @State private var currentScale: CGFloat = 1.0
    @State private var tapLocation: CGPoint = .zero
    
    public init(@ViewBuilder content: () -> ScollContent) {
        self.content = content()
    }
    
    public func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = maxAllowedScale
        scrollView.minimumZoomScale = 1
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.backgroundColor = .clear
        
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        hostedView.backgroundColor = .clear
        scrollView.addSubview(hostedView)
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleDoubleTap(sender:))
        )
        gestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gestureRecognizer)
        
        return scrollView
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(
            hostingController: .init(rootView: content),
            scale: $currentScale,
            location: $tapLocation
        )
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content
        
        // Scale out
        if uiView.zoomScale > uiView.minimumZoomScale {
            uiView.setZoomScale(currentScale, animated: true)
            
        // Scale in to a specific point
        } else if tapLocation != .zero {
            let destination = zoomRect(
                for: uiView,
                scale: uiView.maximumZoomScale,
                center: tapLocation
            )
            uiView.zoom(to: destination, animated: true)
            DispatchQueue.main.async { tapLocation = .zero }
        }
    }
    
    @MainActor func zoomRect(for scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
        let scrollViewSize = scrollView.bounds.size
        
        let width = scrollViewSize.width / scale
        let height = scrollViewSize.height / scale
        let x = center.x - (width / 2.0)
        let y = center.y - (height / 2.0)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public class Coordinator: NSObject, UIScrollViewDelegate {
        
        var hostingController: UIHostingController<ScollContent>
        
        @Binding private var currentScale: CGFloat
        @Binding private var tapLocation: CGPoint
        
        init(
            hostingController: UIHostingController<ScollContent>,
            scale: Binding<CGFloat>,
            location: Binding<CGPoint>
        ) {
            self.hostingController = hostingController
            _currentScale = scale
            _tapLocation = location
        }
        
        public func viewForZooming(in _: UIScrollView) -> UIView? {
            hostingController.view
        }
        
        public func scrollViewDidEndZooming(_: UIScrollView, with _: UIView?, atScale scale: CGFloat) {
            currentScale = scale
        }
        
        @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
            let location = sender.location(in: hostingController.view)
            self.tapLocation = location
            self.currentScale = (currentScale == 1.0) ? maxAllowedScale : 1.0
        }
    }
}
