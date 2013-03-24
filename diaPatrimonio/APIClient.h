//
//  APIClient.h
//  prototipoTabbed2
//
//  Created by Eduardo Alberti on 15-11-12.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"

@interface APIClient : AFHTTPClient
{

}


+ (APIClient *)instance;

-(void)requestCustomWithSuccess:(void (^)(id results))success
                        AndFail:(void (^)(NSError *error))fail;
-(void)requestPuntosCulturalesCercanosWithSuccess:(void (^)(id results))success
                                  AndFail:(void (^)(NSError *error))fail;
-(void)requestPuntosCulturalesEntre:(CLLocationCoordinate2D)puntoNO
                                  Y:(CLLocationCoordinate2D)puntoSE
                        WithSuccess:(void (^)(id results))success
                            AndFail:(void (^)(NSError *error))fail;

@end
