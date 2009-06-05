#import "NSBezierPath+bezierPathWithRoundedRect.h"

@implementation NSBezierPath (bezierPathWithRoundedRect)

+ (NSBezierPath*) bezierPathWithRoundedRect:(NSRect)rect_ {
	return [self bezierPathWithRoundedRect:rect_ radius:10.0];
}

+ (NSBezierPath*) bezierPathWithRoundedRect:(NSRect)rect_ radius:(float)radius_ {
	NSRect centeredArcRect = NSInsetRect(rect_, radius_, radius_);
	
	float bottom = NSMinY(centeredArcRect);
	float left = NSMinX(centeredArcRect);
	float top = NSMaxY(centeredArcRect);
	float right = NSMaxX(centeredArcRect);
	
#define threeOclock		0.0f
#define twelveOclock	90.0f
#define nineOclock		180.0f
#define sixOclock		270.0f
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	// These have to be in order, starting at nine o'clock on the bottom left.
	[path appendBezierPathWithArcWithCenter:NSMakePoint(left, bottom)
									 radius:radius_
								 startAngle:nineOclock
								   endAngle:sixOclock];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(right, bottom)
									 radius:radius_
								 startAngle:sixOclock
								   endAngle:threeOclock];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(right, top)
									 radius:radius_
								 startAngle:threeOclock
								   endAngle:twelveOclock];
	[path appendBezierPathWithArcWithCenter:NSMakePoint(left, top)
									 radius:radius_
								 startAngle:twelveOclock
								   endAngle:nineOclock];
	[path closePath];
	return path;
}

+ (NSBezierPath*)bezierPathWithMissingOutline:(NSRect)rect {
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rect, 2, 2)];
	[path setLineWidth:4];
	float pattern[2] = { 15.0, 5.0 };
	[path setLineDash:pattern count:2 phase:0.0];
	return path;
}

@end