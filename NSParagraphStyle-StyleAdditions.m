#import "NSParagraphStyle-StyleAdditions.h"

@implementation NSParagraphStyle (StyleAdditions)
+ (id)paragraphStyleWithAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)mode
{
  NSMutableParagraphStyle *style;
  
  style = [[NSMutableParagraphStyle alloc] init];
  
  [style setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
  [style setAlignment:alignment];
  [style setLineBreakMode:mode];
  
  return [style autorelease];
}
@end