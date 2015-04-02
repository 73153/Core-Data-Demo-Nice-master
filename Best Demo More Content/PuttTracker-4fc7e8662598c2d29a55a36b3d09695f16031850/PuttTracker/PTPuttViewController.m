#import "PTPuttViewController.h"
#import "PTPutt.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+CoreData.h"
#import "PTHole.h"
#import "PTRound.h"
#import "PTHoleViewController.h"

@interface PTPuttViewController ()

@property (strong, nonatomic) NSMutableArray *buttons;

- (IBAction)buttonClicked:(UIButton *)sender;

@end

@implementation PTPuttViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	[self addBorderToButtons];
	self.title = self.putt == nil ? NSLocalizedString(@"Add Putt", nil) : self.putt.numberAsString;
}

- (void) addBorderToButtons {
	for (UIButton *button in self.buttons) {
		[self addBorderToButton:button];
	}
}

- (NSMutableArray *)buttons {
	if (_buttons == nil || _buttons.count == 0) {
		_buttons = [[NSMutableArray alloc] init];
		
		for (UIButton *button in self.view.subviews) {
			[_buttons addObject:button];
		}
	}
	
	return _buttons;	
}

- (void) addBorderToButton:(UIButton*)button {
	[[button layer] setBorderWidth:1.0f];
	[[button layer] setBorderColor:[UIColor blackColor].CGColor];
}

- (void)setPutt:(PTPutt *)putt {
	_putt = putt;
	[self updateUI];
}

- (void) updateUI {
	[self deselectAllButtons];
	NSInteger tag = self.putt.resultValue;
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag == %d", tag];
	UIButton *button = [[self.buttons filteredArrayUsingPredicate:predicate] lastObject];
	[self setSelected:!button.selected forButton:button];
}

- (IBAction)buttonClicked:(UIButton *)sender {
	PTPutt *putt = nil;
	
	if (self.putt == nil) {
		putt = [PTPutt newEntity];
		putt.numberValue = [PTPutt nextAvailableNumberForHole:self.hole];
	} else {
		putt = self.putt;
	}
	
	putt.resultValue = sender.tag;
	putt.hole = self.hole;
	[self save];
	
	self.putt = putt;
	
	if (putt.resultValue == 5) {
		int nextHoleNumber = self.hole.numberValue + 1;
		PTHole *nextHole = [[[self.hole.round.holes allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"number == %d", nextHoleNumber]] lastObject];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_SHOW_HOLE" object:nextHole];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)deselectAllButtons {
	for (UIButton *button in self.buttons) {
		[self setSelected:NO forButton:button];
	}
}

- (void)setSelected:(BOOL)selected forButton:(UIButton*)button {
	button.selected = selected;
	button.alpha = button.selected ? 0.2 : 1.0;
}

@end
