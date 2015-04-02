#import "PTPuttCell.h"
#import "PTPutt.h"

@implementation PTPuttCell

- (void)setPutt:(PTPutt *)putt {
	_putt = putt;
	[self updateUI];
}

- (void) updateUI {
	self.textLabel.text = self.putt.numberAsString;
	self.detailTextLabel.text = self.putt.description;
}

@end
