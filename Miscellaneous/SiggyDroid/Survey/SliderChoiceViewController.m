//
//  SliderChoiceViewController.m
//  Siggy Droid
//
//  Created by Mac on 12/7/16.
//  Copyright © 2016 bryanmac24. All rights reserved.
//

#import "SliderChoiceViewController.h"

@interface SliderChoiceViewController ()<ASValueTrackingSliderDataSource,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) BOOL internetConnection;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider;
@property (nonatomic) NSMutableArray *answers;
@property (weak, nonatomic)  SurveyClass *survey;
@property (nonatomic) NSMutableArray *checkList;
@end

@implementation SliderChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.internetConnection = YES;
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // create a Reachability object for the internet
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    
    
    self.survey = (SurveyClass *) self.surveys [self.nextQuestionIndex - 1];
    self.checkList = [NSMutableArray new];
    for (NSString *answer in self.survey.answerOptions) {
        if (answer != nil)
            [self.checkList addObject:@"0"];
    }

    self.questionTitleLabel.text =  self.survey.questionTitle;
    if (self.nextQuestionIndex > self.surveys.count -1)
        [self.nextButton setTitle:@"S U B M I T" forState:UIControlStateNormal];
    
    self.slider.minimumValue = [self.survey.answerOptions[0] floatValue];
    self.slider.maximumValue = [self.survey.answerOptions[1] floatValue];
    self.slider.dataSource = self;
    
    self.currentLabel.layer.cornerRadius = 5.0f;
    self.currentLabel.layer.borderColor = GRAY_COLOR.CGColor;
    self.currentLabel.layer.borderWidth = 1.0f;
    self.currentLabel.clipsToBounds = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)helpBtnClicked:(id)sender {
    QLPreviewController *previewController=[[QLPreviewController alloc]init];
    previewController.delegate=self;
    previewController.dataSource=self;
    [self presentModalViewController:previewController animated:YES];
    [previewController.navigationItem setRightBarButtonItem:nil];
}
- (IBAction)nextBtnClicked:(id)sender {
    
    NSMutableArray *currentAnswers = [[CommonFunc getValuesForKey:ANSWERS] mutableCopy];
    NSMutableDictionary *newAnswer = [NSMutableDictionary new];
    [newAnswer setObject:[NSMutableArray arrayWithObject:self.currentLabel.text] forKey:self.survey.questionTitle];
    [currentAnswers addObject:newAnswer];
    [CommonFunc saveUserDefaults:ANSWERS value:currentAnswers];
    
    if (self.nextQuestionIndex > self.surveys.count -1){
        [self sendAnswers];
    } else {
        [self chooseSurveyForm];
    }
}
- (void) sendAnswers{
    if (!self.internetConnection){
        [CommonFunc saveUserDefaults:@"saved_local" value:@"1"];
        [ProgressHUD showSuccess:@"You are offline now. Your answers would be sent to us when you are connected to network" Interaction:NO];
        return;
    }
    [CommonFunc saveUserDefaults:@"saved_local" value:@"0"];
    [YXSpritesLoadingView show];
    NSMutableDictionary *myAnswerDic = [[CommonFunc getValuesForKey:ANSWERS] mutableCopy];
    NSString *currentLocation = [CommonFunc getValuesForKey:@"currentLocation"];
    PFObject *object = [PFObject objectWithClassName:@"Answers"];
    object[@"ResearchID"] = [CommonFunc getValuesForKey:USER_ID];
    object[@"Answer"] = myAnswerDic;
    if (currentLocation)
        object[@"Address"] = currentLocation;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [YXSpritesLoadingView dismiss];
        if(!error) {
            NSLog(@"send answer success");
            
            [ProgressHUD showSuccess:@"Thank you for your answers." Interaction:NO];
            [self gotoMainMenuPage];
            
        }
        else {
            NSString* errorString = [error userInfo][@"error"];
            [ProgressHUD showError:errorString Interaction:NO];
        }
        
    }];
}
- (void) chooseSurveyForm{
    SurveyClass *survey = (SurveyClass *) self.surveys[self.nextQuestionIndex];
    if ([survey.questionType isEqualToString:@"1"]){
        [self gotoSingleSurveyForm];
    }else if ([survey.questionType isEqualToString:@"2"]){
        [self gotoMultipleChoiceSurveyForm];
    }else if ([survey.questionType isEqualToString:@"3"]){
        [self gotoSliderSurveyForm];
    }
}
- (void) gotoSingleSurveyForm{
    SingleChoiceViewController *singleView = [[SingleChoiceViewController alloc] initWithNibName:@"SingleChoiceViewController" bundle:[NSBundle mainBundle]];
    singleView.surveys = [self.surveys mutableCopy];
    singleView.nextQuestionIndex = self.nextQuestionIndex + 1;
    [self.navigationController pushViewController:singleView animated:YES];
}
- (void) gotoMultipleChoiceSurveyForm{
    MultipleChoiceViewController *multipleView = [[MultipleChoiceViewController alloc] initWithNibName:@"MultipleChoiceViewController" bundle:[NSBundle mainBundle]];
    multipleView.surveys = [self.surveys mutableCopy];
    multipleView.nextQuestionIndex = self.nextQuestionIndex + 1;
    [self.navigationController pushViewController:multipleView animated:YES];
}
- (void) gotoSliderSurveyForm{
    SliderChoiceViewController *sliderView = [[SliderChoiceViewController alloc] initWithNibName:@"SliderChoiceViewController" bundle:[NSBundle mainBundle]];
    sliderView.surveys = [self.surveys mutableCopy];
    sliderView.nextQuestionIndex = self.nextQuestionIndex + 1;
    [self.navigationController pushViewController:sliderView animated:YES];
}
#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    NSInteger currentValue =(NSInteger) roundf(value);
    self.currentLabel.text = [NSString stringWithFormat:@"%ld",(long) currentValue];
    return [NSString stringWithFormat:@"%ld",(long) currentValue];
}
- (void) gotoMainMenuPage{
    AppDelegate *appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    MenuViewController *menuView  = [appDel.storyBoard instantiateViewControllerWithIdentifier:@"menuView"];
    [self.navigationController pushViewController:menuView animated:YES];
}
#pragma mark - data source
//Data source methods
//– numberOfPreviewItemsInPreviewController:
//– previewController:previewItemAtIndex:
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"manual.pdf" ofType:nil];
    return [NSURL fileURLWithPath:path];
}

#pragma mark - delegate methods


- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    return YES;
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id <QLPreviewItem>)item inSourceView:(UIView **)view
{
    
    //Rectangle of the button which has been pressed by the user
    //Zoom in and out effect appears to happen from the button which is pressed.
    return self.view.frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
    }
    
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:   {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            //imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            self.internetConnection = NO;
            NSLog(@"network is  bad");
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            //   imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            self.internetConnection = YES;
            NSLog(@"network is  good");
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            self.internetConnection = YES;
            //    imageView.image = [UIImage imageNamed:@"Airport.png"];
            NSLog(@"network is  good");
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    NSString *local_saved = [CommonFunc getValuesForKey:@"saved_local"];
    if (self.internetConnection && local_saved != nil && [local_saved isEqualToString:@"1"]){
        [self sendAnswers];
    }
    // textField.text= statusString;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
