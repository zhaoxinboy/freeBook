//
//  UMUFPImageView.h
//  MMUSDK
//
//  Created by liu yu on 1/17/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@protocol MMUImageViewDelegate;

/**
 
 UMUFPImageView is a subclass of UIImageView class that support remote image loading and cache.
 
 */

@interface MMUImageView : UIImageView {
@private
    NSURL   *_imageURL;
    UIImage *_placeholderImage;    
}

/**
 
 This method return a UMUFPImageView object
 
 @param  anImage placeholder image for the imageview
 
 @return a UMUFPImageView object
 
 */

- (id)initWithPlaceholderImage:(UIImage*)anImage;

/**
 
 This method check whether image for certain url loaded
 
 @param  imageUrl url for a remote image
 
 @return a BOOL value
 
 */

- (BOOL)isCachedImageWithUrl:(NSURL *)imageUrl; //Check whether image for the releated url has been downloaded

@property(nonatomic, retain) NSURL   *imageURL; //Url of the image releated the imageview currently
@property(nonatomic, retain) UIImage *placeholderImage; //Placeholder image for the imageview during image loading progress
@property(nonatomic, weak) id<MMUImageViewDelegate> dataLoadDelegate; //Delegate
@property(nonatomic) NSTimeInterval cacheTimeoutInterval; // Default is 604800 seconds
@property(nonatomic) BOOL shouldRedrawImageToAdaptImageViewSize; //Default is YES, for the case of imageview size is far less than the actual size of releated image, the default zoom strategy of UIImageView may lead to fuzzy(not clear) of the original image. Set shouldRedrawImageToAdaptImageViewSize to YES, UMUFPImageView will handle this case, making original image adapt to the size of UMUFPImageView, while the definition also acceptable.

@property (nonatomic) BOOL shouldShowFadeInAnimation; // fade in animation when image appear, default is NO

@property (nonatomic) BOOL showGif;

@property (nonatomic, assign) NSInteger mTag;
@property (nonatomic, assign) CGPoint mTmpPoint;

@end

/**
 
 delegate is a protocol for UMUFPImageView.
 Optional methods of the protocol allow the delegate to capture UMUFPImageView releated events, and perform other actions.
 
 */

@protocol MMUImageViewDelegate <NSObject>

@optional

- (void)didLoadFinish:(MMUImageView *)imageview; //releated image load finished
- (void)didLoadFailed:(MMUImageView *)imageview; //releated image load failed

- (void)imageView:(MMUImageView *)imageView originalImageSize:(CGSize)imageSize; //actual size for the raw image

@end