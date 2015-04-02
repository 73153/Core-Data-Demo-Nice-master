#import "UIView+Resize.h"

@implementation UIView (Resize)

- (void)setHeight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(float)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setX:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
