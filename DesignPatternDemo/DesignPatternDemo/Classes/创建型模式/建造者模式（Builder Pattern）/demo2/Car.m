//
//  Car.m
//  DesignPatternDemo
//
//      
//  
//

#import "Car.h"

@interface Car ()

@property (nonatomic,strong,readwrite) NSString *carBody;
@property (nonatomic,strong,readwrite) NSString *engine;
@property (nonatomic,strong,readwrite) NSString *tyre;

@end

@implementation Car

- (void)buildCarBody:(NSString *)carBody {
    
    NSLog(@"制造车身：%@",carBody);
    self.carBody = carBody;
}

- (void)buildEngine:(NSString *)engine {
    
    NSLog(@"制造发动机：%@",engine);
    self.engine = engine;
}

- (void)buildTyre:(NSString *)tyre {
    
    NSLog(@"制造轮胎：%@",tyre);
    self.tyre = tyre;
}

@end
