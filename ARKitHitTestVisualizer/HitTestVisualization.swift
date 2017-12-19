/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Controller class manages a demo of ARKit hit testing.
*/

import Foundation
import ARKit

public class HitTestVisualization {
	
	public var minHitDistance: CGFloat = 0.01
    public var maxHitDistance: CGFloat = 4.5
	public var xAxisSamples = 6
	public var yAxisSamples = 6
	public var fieldOfViewWidth: CGFloat = 0.8
	public var fieldOfViewHeight: CGFloat = 0.8
	
	fileprivate let hitTestPointParentNode = SCNNode()
	fileprivate var hitTestPoints = [SCNNode]()
	fileprivate var hitTestFeaturePoints = [SCNNode]()
	
	public let sceneView: ARSCNView
	fileprivate let overlayView = LineOverlayView()
	
	public init(sceneView: ARSCNView) {
		self.sceneView = sceneView
		overlayView.backgroundColor = UIColor.clear
		overlayView.frame = sceneView.frame
		sceneView.addSubview(overlayView)
	}
	
	deinit {
		hitTestPointParentNode.removeFromParentNode()
		overlayView.removeFromSuperview()
	}
	
	internal func setupHitTestResultPoints() {
		if hitTestPointParentNode.parent == nil {
			self.sceneView.scene.rootNode.addChildNode(hitTestPointParentNode)
		}
		
		while hitTestPoints.count < xAxisSamples * yAxisSamples {
            hitTestPoints.append(createCrossNode(size: 0.01, color:UIColor.blue, horizontal:false))
            hitTestFeaturePoints.append(createCrossNode(size: 0.01, color:UIColor.yellow, horizontal:true))
		}
	}
	
	public func render() {
		
		// Remove any old nodes,
		hitTestPointParentNode.childNodes.forEach {
			$0.removeFromParentNode()
			$0.geometry = nil
		}
		
		// Ensure there are enough nodes that can be rendered.
		setupHitTestResultPoints()
		
		let xAxisOffset: CGFloat = (1 - fieldOfViewWidth) / 2
		let yAxisOffset: CGFloat = (1 - fieldOfViewHeight) / 2
		
		let stepX = fieldOfViewWidth / CGFloat(xAxisSamples - 1)
		let stepY = fieldOfViewHeight / CGFloat(yAxisSamples - 1)
		
		var screenSpaceX: CGFloat = xAxisOffset
		var screenSpaceY: CGFloat = yAxisOffset
		
		guard let currentFrame = sceneView.session.currentFrame else {
			return
		}
		
		for x in 0 ..< xAxisSamples {
			
			screenSpaceX = xAxisOffset + (CGFloat(x) * stepX)
			
			for y in 0 ..< yAxisSamples {
				
				screenSpaceY = yAxisOffset + (CGFloat(y) * stepY)
				
				let hitTestPoint = hitTestPoints[(x * yAxisSamples) + y]
				
				let hitTestResults = currentFrame.hitTest(CGPoint(x: screenSpaceX, y: screenSpaceY), types: .featurePoint)
				
				if hitTestResults.isEmpty {
					hitTestPoint.isHidden = true
					continue
				}
				
				hitTestPoint.isHidden = false
				
				let result = hitTestResults[0]
				
				// Place a blue cross, oriented parallel to the screen at the place of the hit.
				let hitTestPointPosition = SCNVector3.positionFromTransform(result.worldTransform)
				
				hitTestPoint.position = hitTestPointPosition
				hitTestPointParentNode.addChildNode(hitTestPoint)
				
				// Subtract the result's local position from the world position to get the position of the feature which the ray hit.
				let localPointPosition = SCNVector3.positionFromTransform(result.localTransform)
				let featurePosition = hitTestPointPosition - localPointPosition
				
				let hitTestFeaturePoint = hitTestFeaturePoints[(x * yAxisSamples) + y]
				
				hitTestFeaturePoint.position = featurePosition
				hitTestPointParentNode.addChildNode(hitTestFeaturePoint)
				
				// Create a 2D line between the feature point and the hit test result to be drawn on the overlay view.
				overlayView.addLine(start: screenPoint(for: hitTestPointPosition), end: screenPoint(for: featurePosition))
                
			}
		}
		// Draw the 2D lines
		DispatchQueue.main.async {
			self.overlayView.setNeedsDisplay()
		}
	}
	
	private func screenPoint(for point: SCNVector3) -> CGPoint {
		let projectedPoint = sceneView.projectPoint(point)
		return CGPoint(x: CGFloat(projectedPoint.x), y: CGFloat(projectedPoint.y))
	}
}
