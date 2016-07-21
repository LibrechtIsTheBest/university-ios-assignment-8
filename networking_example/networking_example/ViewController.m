#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "ReposViewController.h"


@interface ViewController () <UITextFieldDelegate>

@property (nonatomic) GITHUBAPIController *controller;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UIButton *button;
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) UIView *grayView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL grayMode;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.grayView.center;
    [self.grayView addSubview:self.activityIndicator];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showRepos];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showRepos];
}

- (void)showRepos
{
    self.grayMode = YES;
    
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller getReposInfoForUser:userName success:^(NSArray *repos) {
        
        ReposViewController *reposViewController = [wself.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReposViewController class])];
        reposViewController.repositories = repos;
        wself.grayMode = NO;
        [wself.navigationController pushViewController:reposViewController animated:YES];
        
    } failure:^(NSInteger responseStatusCode, NSError *error) {
        
        wself.grayMode = NO;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
        [wself presentViewController:alertController animated:YES completion:NULL];
    }];
}

- (void)setGrayMode:(BOOL)grayMode
{
    _grayMode = grayMode;
    if (_grayMode) {
        
        [self.view addSubview:self.grayView];
        [self.activityIndicator startAnimating];
    }
    else {
        
        [self.activityIndicator stopAnimating];
        [self.grayView removeFromSuperview];
    }
}

@end

















