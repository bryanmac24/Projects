//
//  SingleChoiceViewController.m
//  Siggy Droid
//
//  Created by Mac on 12/7/16.
//  Copyright © 2016 bryanmac24. All rights reserved.
//

#import "SingleChoiceViewController.h"

@interface SingleChoiceViewController ()<UITableViewDelegate, UITableViewDataSource,BEMCheckBoxDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) BOOL internetConnection;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic)  SurveyClass *survey;
@property (nonatomic) NSMutableArray *answers;
@property (nonatomic) NSMutableArray *checkList;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger nextID;

@end

@implementation SingleChoiceViewController

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

    
//    self.internetReachability = [Reachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
//    [self updateInterfaceWithReachability:self.internetReachability];


    self.survey = (SurveyClass *) self.surveys [self.nextQuestionIndex - 1];
    
    self.checkList = [NSMutableArray new];
    for (NSString *answer in self.survey.answerOptions) {
        if (answer != nil)
            [self.checkList addObject:@"0"];
    }
    
    self.optionsTableView.delegate  = self;
    self.optionsTableView.dataSource = self;
    self.optionsTableView.showsVerticalScrollIndicator = YES;
    self.optionsTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.optionsTableView flashScrollIndicators];
    self.optionsTableView.separatorColor = CLEAR_COLOR;
    self.questionTitleLabel.text =  self.survey.questionTitle;
    if (self.nextQuestionIndex > self.surveys.count -1)
        [self.nextButton setTitle:@"S U B M I T" forState:UIControlStateNormal];
 

}

-(void)viewDidAppear:(BOOL)animated{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}
-(void)indicator:(BOOL)animated{
    [self.optionsTableView flashScrollIndicators];
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
    BOOL hasAnswer = NO;
    for (NSString *state in self.checkList) {
        if ([state isEqualToString:@"1"])
        {
            hasAnswer = YES;
        }
    }
    if (!hasAnswer)
    {
        NSLog(@"You didn;t choose any answer");
    }else {
        

        
        
        NSMutableArray *currentAnswers = [[CommonFunc getValuesForKey:ANSWERS] mutableCopy];
        NSMutableDictionary *newAnswer = [NSMutableDictionary new];
        [newAnswer setObject:self.answers forKey:self.survey.questionTitle];
        [currentAnswers addObject:newAnswer];
        [CommonFunc saveUserDefaults:ANSWERS value:currentAnswers];
        
        if (self.nextQuestionIndex > self.surveys.count -1){
            [self sendAnswers];
        } else {
            [self chooseSurveyForm];
        }
        
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

     self.nextID  = [self.survey.nextQuestionIDs[0] integerValue];


    if (self.survey.answerOptions.count == self.survey.nextQuestionIDs.count){

        NSInteger index = 0;
        for (NSInteger index = 0 ; index < self.survey.answerOptions.count; index ++) {
            if ([self.answers[0] isEqualToString:self.survey.answerOptions[index]]){
                self.nextID = [self.survey.nextQuestionIDs[index] integerValue];
            }
        }
    }


    SurveyClass *survey = (SurveyClass *) self.surveys[self.nextID -1];
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
    singleView.nextQuestionIndex = self.nextID ;
    [self.navigationController pushViewController:singleView animated:YES];
}
- (void) gotoMultipleChoiceSurveyForm{
    MultipleChoiceViewController *multipleView = [[MultipleChoiceViewController alloc] initWithNibName:@"MultipleChoiceViewController" bundle:[NSBundle mainBundle]];
    multipleView.surveys = [self.surveys mutableCopy];
    multipleView.nextQuestionIndex = self.nextID;
    [self.navigationController pushViewController:multipleView animated:YES];
}
- (void) gotoSliderSurveyForm{
    SliderChoiceViewController *sliderView = [[SliderChoiceViewController alloc] initWithNibName:@"SliderChoiceViewController" bundle:[NSBundle mainBundle]];
    sliderView.surveys = [self.surveys mutableCopy];
    sliderView.nextQuestionIndex = self.nextID;
    [self.navigationController pushViewController:sliderView animated:YES];
}


#pragma UITableView Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.survey.answerOptions.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"singleChoiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [CommonFunc removeSubViewsOfview:cell];
    
    BEMCheckBox *checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    checkBox.animationDuration = 0.1;
    checkBox.on = NO;
    checkBox.tag = indexPath.row  + 100;
    if ([self.checkList[indexPath.row] isEqualToString:@"1"])
    {
        checkBox.on = YES;
        self.answers = [NSMutableArray arrayWithObject:self.survey.answerOptions[indexPath.row]];
    }
    checkBox.delegate = self;
    [cell addSubview:checkBox];
    
    
    UILabel * optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.view.frame.size.width - 70, 60)];
    optionLabel.textAlignment = NSTextAlignmentLeft;
    optionLabel.numberOfLines = 0;
    optionLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0f];
    optionLabel.textColor = BLACK_COLOR;
    optionLabel.text = self.survey.answerOptions[indexPath.row];
    [cell addSubview:optionLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma BEMCheckBox Delegate
- (void) didTapCheckBox :(BEMCheckBox *) checkBox{
    
    NSInteger row = checkBox.tag - 100;

    NSString *newState = @"0";
    if (checkBox.on)
        newState = @"1";
    NSMutableArray *newCheckList = [NSMutableArray new];
    for (NSInteger index = 0; index  < self.checkList.count ; index ++)
    {
        if (index == row)
        {
            [newCheckList addObject:newState];
        } else {
            [newCheckList addObject:@"0"];
        }
    }
    
    self.checkList = [newCheckList mutableCopy];
    
    [self.optionsTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
/*!
 * Called by Reachability whenever status changes.
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
        case NotReachable:        {
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
            self.internetConnection = YES;
            NSLog(@"network is  good");
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            self.internetConnection = YES;
            NSLog(@"network is  good");
        //    imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
   // textField.text= statusString;
    NSString *local_saved = [CommonFunc getValuesForKey:@"saved_local"];
    if (self.internetConnection && local_saved != nil && [local_saved isEqualToString:@"1"]){
        [self sendAnswers];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
