#import "PTRoundCell.h"
#import "PTRound.h"
#import "NSDate+Formatting.h"

@implementation PTRoundCell

- (void)setRound:(PTRound *)round {
	_round = round;
	[self updateUI];
}

- (void) updateUI {
	self.textLabel.text = self.round.location;
	self.detailTextLabel.text = self.round.date.stringFromDate;
}

@end
