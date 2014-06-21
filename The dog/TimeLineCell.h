//
//  TimeLineCell.h
//  The dog
//
//  Created by 木村 友真 on 2014/06/20.
//  Copyright (c) 2014年 yuma kimura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell

@property (nonatomic, strong) UILabel *tweetTextLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic) CGFloat tweetTextLabelHeight;

@end
