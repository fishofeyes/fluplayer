//
//  InstantSupervisor.h
//  LuckyGame
//
//  Created by LuckyGame on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WKWebView;

NS_ASSUME_NONNULL_BEGIN

@interface InstantSupervisor : NSObject

+ (InstantSupervisor *)defaultController;

//controller中调用，设置环境
- (void)finishCanvas:(UIViewController *)rootVC removeMetal:(UIView *)gameView;

//移除View
- (void)fadeAlley;

//加载BasicConfig
- (void)fadeData;

//加载OfferConfig if success,load success.
- (void)resumeAlley;

//显示WebView
- (void)pasteParticle;
@property (nonatomic, strong) WKWebView *upgradeGrid;
@property (nonatomic, assign) BOOL customField;
@property (nonatomic, copy) NSString *deviceFrame;
@end

NS_ASSUME_NONNULL_END
