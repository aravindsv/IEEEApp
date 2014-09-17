//
//  CheckInViewController.m
//  UCLA IEEE
//
//  Created by Aravind Vadali on 9/10/14.
//  Copyright (c) 2014 Aravind Vadali. All rights reserved.
//

#import "CheckInViewController.h"
#import "UserInfo.h"
#import "DataManager.h"
#import "Event.h"

@interface CheckInViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventTiming;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;

-(BOOL)startReading;
-(void)stopReading;


@end

@implementation CheckInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isReading = YES;
    self.captureSession = nil;
    [self startReading];
    self.eventTiming.hidden = YES;
    self.eventName.hidden = YES;
    self.eventLocation.hidden = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startReading)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.viewPreview addGestureRecognizer:gestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)startReading
{
    NSError *error;
    //Set up a capture device to capture video
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //set up an object to recieve the input from captureDevice
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //set up the capture session to send input to previously defined input
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    //set up a variable for the captureSession to put it's output into
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    //set captureSession metadata output to a readable format by specifying type of metadata
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //show the user the camera view
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    //start the camera
    [self.captureSession startRunning];
    
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) //Make sure metadataObjects has at least one item in it
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0]; //We only care about the first item in metadataObjects
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) //check if the first item is a readable QR code
        {
            //[metadataObj stringValue]
            [DataManager checkInToEvent:[metadataObj stringValue] withEmail:[UserInfo sharedInstance].userMail andCookie:[UserInfo sharedInstance].userCookie onComplete:^{
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                [self.scanLabel performSelectorOnMainThread:@selector(setText:) withObject:@"Tap to rescan" waitUntilDone:NO];
                [self.eventName performSelectorOnMainThread:@selector(setText:) withObject:[Event currentEvent].summary waitUntilDone:NO];
                [self.eventTiming performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ to %@", [Event currentEvent].startTime, [Event currentEvent].endTime] waitUntilDone:NO];
                [self.eventLocation performSelectorOnMainThread:@selector(setText:) withObject:[Event currentEvent].location waitUntilDone:NO];
                [self toggleEventDetails];
            }];
            [self stopReading];
        }
    }
}

-(void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
}

-(void)toggleEventDetails
{
    self.eventName.hidden = !self.eventName.hidden;
    self.eventLocation.hidden = !self.eventName.hidden;
    self.eventTiming.hidden = !self.eventName.hidden;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
