//
//  BFTRepoSectionFooter.m
//  RepoSearch
//
//

#import "BFTRepoSectionFooter.h"

@implementation BFTRepoSectionFooter {
    UILabel *_tipLabel;
    UIButton *_loadButton;
}

+ (NSString *)footerIdentifier {
    return @"BFTRepoSectionFooter";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __createView];
    }
    return self;
}

- (void)__createView {
    _tipLabel = [UILabel new];
    [self addSubview:_tipLabel];
    _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_tipLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [_tipLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    _loadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loadButton setTitle:@"Load More" forState:UIControlStateNormal];
    [self addSubview:_loadButton];
    _loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_loadButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [_loadButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

@end
