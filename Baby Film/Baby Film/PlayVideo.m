//
//  PlayVideo.m
//  VideoPlayRecord
//
//  Created by Abdul Azeem Khan on 5/9/12.
//  Copyright (c) 2012 DataInvent. All rights reserved.
//

#import "PlayVideo.h"

@implementation PlayVideo

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)PlayVideo:(id)sender {
    [self startMediaBrowserFromViewController: self usingDelegate: self];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate{
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    // 3 - Display iamge picker
    [self presentViewController:mediaUI animated:YES completion:nil];
    return YES;
    
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    // 1 - Get image type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // 2 - Dismiss iamge picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        // 3 - Play the video
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        MPMoviePlayerViewController* theMovie =
        [[MPMoviePlayerViewController alloc] initWithContentURL: [info objectForKey:
                                                                  UIImagePickerControllerMediaURL]];
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        
        // 4 - Register for the playback finished notification
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(myMovieFinishedCallback:)
         name: MPMoviePlayerPlaybackDidFinishNotification
         object: theMovie];
        
        
    }
}

// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];
    // Release the movie instance created in playMovieAtURL:
}

@end
