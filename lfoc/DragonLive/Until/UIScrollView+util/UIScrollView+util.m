//
//  UIScrollView+util.m
//  DragonLive
//
//  Created by LoaA on 2021/1/2.
//

#import "UIScrollView+util.h"

@interface UIScrollView (util)

@end

@implementation UIScrollView (util)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[self nextResponder] touchesBegan:touches withEvent:event];

    [super touchesBegan:touches withEvent:event];

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[self nextResponder] touchesMoved:touches withEvent:event];

    [super touchesMoved:touches withEvent:event];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[self nextResponder] touchesEnded:touches withEvent:event];

    [super touchesEnded:touches withEvent:event];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
