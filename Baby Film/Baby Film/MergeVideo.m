//
//  MergeVideo.m
//  VideoPlayRecord
//
//  Created by Abdul Azeem Khan on 5/9/12.
//  Copyright (c) 2012 DataInvent. All rights reserved.
//

#import "MergeVideo.h"

@implementation MergeVideo
@synthesize ActivityView;
@synthesize firstAsset, secondAsset, audioAsset;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"Loaded");
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
#pragma mark - Load assests methods

- (IBAction)LoadAssetOne:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];        
    }else{
        isSelectingAssetOne = TRUE;
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];  
    }
}
- (IBAction)LoadAssetTwo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
        
    }else{
        isSelectingAssetOne = FALSE;
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];  
    }
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [self presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}

- (IBAction)LoadAudio:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select Music";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}


#pragma mark - Conform MPMediaPickerControllerDelegate
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    NSArray * SelectedSong = [mediaItemCollection items];
    if([SelectedSong count]>0){
        MPMediaItem * SongItem = [SelectedSong objectAtIndex:0];
        NSURL *SongURL = [SongItem valueForProperty: MPMediaItemPropertyAssetURL];
        
        audioAsset = [AVAsset assetWithURL:SongURL];
         NSLog(@"Audio Loaded");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Audio Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
         [alert show];
    }
    
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
    [self dismissViewControllerAnimated: YES completion:nil];

}


#pragma mark - Conform UIImagePickerControllerDelegate
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated: YES completion:nil];
}


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        if(isSelectingAssetOne){
            NSLog(@"Video One  Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video One Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
            firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }else{
            NSLog(@"Video two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video Two Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
            secondAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];        
        }
    }
}


#pragma mark - MergeAndSave methods

- (IBAction)MergeAndSave:(id)sender {
    
    if(firstAsset !=nil && secondAsset!=nil) {
        
        [ActivityView startAnimating];
        
        // 1 - Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        // AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
        // 2 - VIDEO TRACK
        // AVMutableCompositionTrack lets you for insert, remove, and scale track segments without affecting their low-level representation (that is, the operations you perform are non-destructive on the original).
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
       
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
        
        // 3 - AUDIO TRACK
        if(audioAsset!=nil) {
            
            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        } 
        
        // 4 - Set AVMutableVideoCompositionLayerInstruction
        // AVMutableVideoCompositionLayerInstruction used to modify the transform, cropping, and opacity ramps to apply to a given track in a composition.
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        if(isFirstAssetPortrait_){
            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
        CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
        }
        
       
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
        
        
        // 5 - Mergo AVMutableVideoCompositionLayerInstruction into AVMutableVideoComposition
        // AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
        
        // 6 - Get path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];	
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        // 7 - Create exporter with AVAssetExportSession
        // An AVAssetExportSession object transcodes the contents of an AVAsset source object to create an output of the form described by a specified export preset.
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self exportDidFinish:exporter];
             });
         }];
    }
}

// exportDidFinish method: save the mergo video to Photos Album
- (void)exportDidFinish:(AVAssetExportSession*)session {
    
    if(session.status == AVAssetExportSessionStatusCompleted) {
        
        NSURL *outputURL = session.outputURL;
        
        // An instance of ALAssetsLibrary provides access to the videos and photos that are under the control of the Photos application.
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                                                    [alert show];
                                                    }else{
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                                    [alert show];
                                                     }
                                                
                                            });
                                            
                                        }];
        } 
    }
	
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
    [ActivityView stopAnimating];
}
@end
