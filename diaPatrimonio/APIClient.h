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
-(void) requestCompletarInformacionPuntoCulturalConIDPunto:(NSNumber *)id_punto
                                                AndSuccess:(void (^)(NSDictionary *informacionPunto))success
                                                   AndFail:(void (^)(NSError *error))fail;
-(void)requestDescargarImagenAsincronaWithURLString:(NSString *)url_string
                                            success:(void (^)(id results, NSError *error))block
                              downloadProgressBlock:(void (^) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock;

@end
