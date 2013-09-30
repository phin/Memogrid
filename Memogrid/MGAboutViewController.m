//
//  MGAboutViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGAboutViewController.h"


@interface MGAboutViewController ()

@end

@implementation MGAboutViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void) initUI {
    self.view.backgroundColor = C_BACK;
}

- (IBAction) shareFacebook {
    [self actionShareOnFacebook:NSLocalizedString(@"social", nil)];
}

- (IBAction) shareTwitter {
    [self actionShareOnTwitter:NSLocalizedString(@"social", nil)];
}

- (IBAction) sendFeedback {
    [self showPicker];
}

- (IBAction) backToMenu:(id)sender
{
    [self dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
}

#pragma mark -
#pragma mark Compose Mail

-(void)showPicker
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		if ([mailClass canSendMail]) {
			[self displayComposerSheet];
		}
	}
}

-(void)displayComposerSheet
{
    // Get some info on the Device
    NSString *s_infos = [NSString stringWithFormat:@"<br/><br/>Device: %@ Version: %@", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"memogrid@phin.fr"]];
	[picker setSubject:@"Feedback Memogrid 1.0"];
    [picker setMessageBody:s_infos isHTML:YES];
    
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
