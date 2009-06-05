#import "BBMessage.h"

@implementation BBMessage
- (id)replacementObjectForPortCoder:(NSPortCoder *)aCoder
{
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{  
  self = [super init];
  
  if (self)
  {
    _emlxFile = [[coder decodeObject] retain];
    _headers = [[coder decodeObject] retain];
    _body = [[coder decodeObject] retain];
    _mailbox = [[coder decodeObject] retain];
    _uncommentedSender = [[coder decodeObject] retain];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_emlxFile];
  [encoder encodeObject:_headers];
  [encoder encodeObject:_body];
  [encoder encodeObject:_mailbox];
  [encoder encodeObject:_uncommentedSender];
}

- (void)dealloc
{
  [self setEmlxFile:nil];
  [self setHeaders:nil];
  [self setMailbox:nil];
  [self setBody:nil];
  [super dealloc];
}

- (NSString*)description
{
  return [NSString stringWithFormat:@"emlxFile = %@\nheaders = %@\nbody =  %@",_emlxFile, _headers, _body];
}
- (void)setMailbox:(NSString*)mailbox
{
  [_mailbox release];
  _mailbox = mailbox;
  [_mailbox retain];
}

- (void)setEmlxFile:(NSString*)emlxFile
{
  [_emlxFile release];
  _emlxFile = emlxFile;
  [_emlxFile retain];
}

- (void)setHeaders:(NSDictionary*)headers
{
  [_headers release];
  _headers = headers;
  [_headers retain];
}

- (void)setBody:(NSAttributedString*)body
{
  [_body release];
  _body = body;
  [_body retain];
}

- (void)setUncommentedSender:(NSString*)uncommentedSender
{
  [_uncommentedSender release];
  _uncommentedSender = uncommentedSender;
  [_uncommentedSender retain];
}

- (NSString *)mailbox
{
  return _mailbox;
}

- (NSString*)emlxFile
{
  return _emlxFile;
}

- (NSDictionary*)headers
{
  return _headers;
}

- (NSAttributedString*)body
{
  return _body;
}
- (NSString*)uncommentedSender
{
  return _uncommentedSender;
}
@end
