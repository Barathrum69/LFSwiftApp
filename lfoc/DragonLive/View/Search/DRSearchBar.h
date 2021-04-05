//
//  DRSearchBar.h
//  DragonLive
//
//  Created by 11号 on 2020/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DRSearchBar;
@protocol DRSearchViewDelegate<UIBarPositioningDelegate>

@optional

- (BOOL)searchBarShouldBeginEditing:(DRSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(DRSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(DRSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(DRSearchBar *)searchBar;
- (void)searchBar:(DRSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (BOOL)searchBar:(DRSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)searchBarSearchButtonClicked:(DRSearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(DRSearchBar *)searchBar;

@end

@interface DRSearchBar : UIView

@property(nonatomic,copy)   NSString              * text;

@property(nonatomic,strong) UIColor               * textColor;

@property(nonatomic,strong) UIFont                * textFont;

@property(nonatomic,copy)   NSString              * placeholder;

@property(nonatomic,strong) UIColor               * placeholderColor;

@property(nonatomic,strong) UIImage               * iconImage;

@property(nonatomic,strong) UIImage               * backgroundImage;

@property(nonatomic,strong) UIButton              * cancelButton; //lazy


@property(nonatomic,assign) UITextBorderStyle       textBorderStyle;

@property(nonatomic)        UIKeyboardType          keyboardType;


@property (nonatomic, strong) UIView   * inputAccessoryView;

@property (nonatomic, strong) UIView   * inputView;

@property (nonatomic, weak) id<DRSearchViewDelegate> delegate;

- (BOOL)becomeFirstResponder;

- (BOOL)resignFirstResponder;

- (void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type;

@end

NS_ASSUME_NONNULL_END
