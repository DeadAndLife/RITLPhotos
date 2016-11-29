//
//  YPPhotoGroupCell.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_DEPRECATED_IOS(2_0, 10_0,"Use RITLPhotoGroupCell instead.") @interface RITLPhotoGroupCellOld : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView * imageView;
@property (strong, nonatomic) IBOutlet UILabel * titleLabel;

/// @brief 种类类别的ImageView,暂时无用
@property (strong, nonatomic) IBOutlet UIImageView * categoryImageView;

@end

NS_ASSUME_NONNULL_END
