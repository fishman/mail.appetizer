#import "NSBezierPath-MailAppetizerAdditions.h"

@implementation NSBezierPath (MailAppetizerAdditions)
+ (NSBezierPath*) bezierPathWithRoundedRect:(NSRect)aRect
                                     radius:(float)radius
{                                       
  NSBezierPath *path = [NSBezierPath bezierPath];

  NSPoint bl = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
  NSPoint br = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
  NSPoint tl = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
  NSPoint tr = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));

  [path moveToPoint: NSMakePoint(bl.x + radius, bl.y)];

  [path appendBezierPathWithArcFromPoint: br toPoint: tr radius: radius];
  [path appendBezierPathWithArcFromPoint: tr toPoint: tl radius: radius];
  [path appendBezierPathWithArcFromPoint: tl toPoint: bl radius: radius];
  [path appendBezierPathWithArcFromPoint: bl toPoint: br radius: radius];

  [path closePath];
  return path;
}
@end