#import "PTRoundDetailsViewController.h"
#import "PTRound.h"
#import "UIViewController+CoreData.h"
#import "NSDate+Formatting.h"
#import "NSObject+Alerts.h"
#import "NSString+Trimming.h"

@interface PTRoundDetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender;
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender;
- (IBAction)datePickerViewValueChanged:(UIDatePicker *)sender;

@end

@implementation PTRoundDetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.date.inputView = self.datePickerView;
	self.date.text = self.datePickerView.date.stringFromDate;
	[self.location becomeFirstResponder];
	self.title = NSLocalizedString(@"Add Round", nil);
}

- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
	if (self.location.text.trim.length > 0) {
		PTRound *round = [PTRound newEntity];
		round.location = self.location.text.trim;
		round.date = [NSDate dateFromString:self.date.text];
		[self save];
		
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[self showAlertWithMessage:NSLocalizedString(@"Location is required", nil)];
	}
}

- (IBAction)datePickerViewValueChanged:(UIDatePicker *)sender {
	self.date.text = sender.date.stringFromDate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return textField == self.date ? NO : YES;
}

@end
