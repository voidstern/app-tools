//
//  GeometryHelpers.swift
//  Notes
//
//  Created by Lukas Burgstaller on 16.03.23.
//

import Foundation

struct CGLine {
    let start: CGPoint
    let end: CGPoint
}

struct CGCircle {
    let center: CGPoint
    let radius: CGFloat
}

struct CGEllipse {
    let center: CGPoint
    let radiusX: CGFloat
    let radiusY: CGFloat
}

extension CGFloat {
    var degrees: Double {
        return self * 180 / Double.pi
    }
    
    var radians: Double {
        return self * Double.pi / 180
    }
}

extension CGPoint {
    func rotated(around center: CGPoint, by degrees: CGFloat) -> CGPoint {
        let s: CGFloat = CGFloat(sin(degrees.radians))
        let c: CGFloat = CGFloat(cos(degrees.radians))
        
        let centeredPoint = CGPoint(x: x - center.x, y: y - center.y)
        let rotatedPoint = CGPoint(x: (centeredPoint.x * c) - (centeredPoint.y * s), y: (centeredPoint.x * s) + (centeredPoint.y * c))
        
        return CGPoint(x: rotatedPoint.x + center.x, y: rotatedPoint.y + center.y)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    func distance(to rect: CGRect) -> CGFloat {
        let dx: CGFloat
        let dy: CGFloat
        
        if x < rect.minX {
            dx = rect.minX - x
        } else if x > rect.maxX {
            dx = x - rect.maxX
        } else {
            dx = min(x - rect.minX, rect.maxX - x)
        }
        
        if y < rect.minY {
            dy = rect.minY - y
        } else if y > rect.maxY {
            dy = y - rect.maxY
        } else {
            dy = min(y - rect.minY, rect.maxY - y)
        }
        
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    func angle(to point: CGPoint) -> CGFloat {
        let originX = point.x - x
        let originY = point.y - y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees

        while bearingDegrees < 0 {
            bearingDegrees += 360
        }

        return bearingDegrees
    }
    
    func distance(to line: CGLine) -> CGFloat {
        let x0 = x
        let y0 = y
        let x1 = line.start.x
        let y1 = line.start.y
        let x2 = line.end.x
        let y2 = line.end.y
        
        let t = abs(((x2 - x1) * (y1 - y0)) - ((x1 - x0) * (y2 - y1)))
        let b = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
        return t / b
    }
    
    func distance(to circle: CGCircle) -> CGFloat {
        let dc = circle.center.distance(to: self)
        return abs(dc - circle.radius)
    }
    
    func distance(to ellipse: CGEllipse) -> CGFloat {
        let closestPoint = ellipse.closestPoint(to: self)
        let distance = closestPoint.distance(to: self)
        return distance
    }
    
    func degrees(to point: CGPoint) -> CGFloat {
        let center = CGPoint(x: point.x - x, y: point.y - y)
        let radians = atan2(center.y, center.x)
        let degrees = radians * 180 / .pi
        return degrees > 0 ? degrees : 360 + degrees
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    func totalStrokeLength() -> CGFloat {
        return ((maxX - minX) * 2) + ((maxY - minY) * 2)
    }
    
    func fittedCircle() -> CGCircle {
        return CGCircle(center: center, radius: min(height / 2, width / 2))
    }
    
    func fittedEllipse() -> CGEllipse {
        return CGEllipse(center: center, radiusX: width / 2, radiusY: height / 2)
    }
    
    func averageSquare() -> CGRect {
        let size = (width + height) / 2
        return CGRect(x: midX - (size / 2), y: midY - (size / 2), width: size, height: size)
    }
}

extension CGLine {
    func totalStrokeLength() -> CGFloat {
        return start.distance(to: end)
    }
}

extension CGCircle {
    func totalStrokeLength() -> CGFloat {
        return 2 * radius * .pi
    }
}

extension CGEllipse {
    func totalStrokeLength() -> CGFloat {
        // Ramanujan approximation
        return (Double.pi * (radiusX + radiusY)) - sqrt(((3 * radiusX) + radiusY) + (radiusX + (3 * radiusY)))
    }
    
    // From http://wwwf.imperial.ac.uk/~rn/distance2ellipse.pdf
    func closestPoint(to p: CGPoint, maxIterations: Int = 10) -> CGPoint {
        
        let eps = CGFloat(0.1 / max(radiusX, radiusY))
        let p1 = CGPoint(x: p.x - center.x, y: p.y - center.y)

        // Intersection of straight line from origin to p with ellipse
        // as the first approximation:
        var phi = atan2(radiusX * p1.y, radiusY * p1.x)

        // Newton iteration to find solution of
        // f(θ) := (a^2 − b^2) cos(phi) sin(phi) − x a sin(phi) + y b cos(phi) = 0:
        for _ in 0..<maxIterations {
            // function value and derivative at phi:
            let (c, s) = (cos(phi), sin(phi))
            let f = (radiusX * radiusX - radiusY * radiusY) * c * s - p1.x * radiusX * s + p1.y * radiusY * c
            let f1 = (radiusX * radiusX - radiusY * radiusY) * (c * c - s * s) - p1.x * radiusX * c - p1.y * radiusY * s

            let delta = f/f1
            phi = phi - delta
            if abs(delta) < eps { break }
        }

        return CGPoint(x: center.x + radiusX * cos(phi), y: center.y + radiusY * sin(phi))
    }
}
