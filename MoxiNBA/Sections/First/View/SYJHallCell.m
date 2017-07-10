//
//  SYJHallCell.m
//  MoxiNBA
//
//  Created by 尚勇杰 on 2017/7/4.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJHallCell.h"

#define mImageByName(name)        [UIImage imageNamed:name]

#define CustomGray RGBA(160, 160, 160, 1) // 灰色


@implementation SYJHallCell



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
      
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
        self.label.font = [UIFont systemFontOfSize:16];
        self.label.textColor = [UIColor darkGrayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.sd_layout.leftSpaceToView(self.contentView, 5).centerYEqualToView(self.contentView).heightIs(20).widthIs(90);
        
        

        self.imgIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:self.imgIcon];
        self.imgIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.imgIcon.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(35).heightIs(22);
        
        
//        self.imgIcon.frame = CGRectMake(CGRectGetWidth(self.frame) - kDefaultInset.right * 1.5 - self.imgIcon.image.size.width, (CGRectGetHeight(self.frame) - self.imgIcon.image.size.height) / 2, self.imgIcon.image.size.width, self.imgIcon.image.size.height);
//        
//        self.label.frame = CGRectMake(kDefaultInset.left * 1.5, 0, CGRectGetWidth(self.frame) - kDefaultInset.left * 2 - self.imgIcon.image.size.width, CGRectGetHeight(self.frame));

        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect
{
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect) - .1, 0) end:CGPointMake(CGRectGetWidth(rect) - .1, CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.5];
    [self drawRectWithLine:rect start:CGPointMake(0, CGRectGetHeight(rect)) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomGray lineWidth:.5];
}


- (void)setDatallist:(id)datallist{
    
    _datallist = datallist;
    self.label.text = datallist[@"title"];
    self.imgIcon.image = mImageByName(datallist[@"image"]);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
