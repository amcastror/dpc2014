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

-(void)requestPuntosCulturalesCercanosWithSuccess:(void (^)(id results))success
                                  AndFail:(void (^)(NSError *error))fail;
-(void)requestPuntosCulturalesEntre:(CLLocationCoordinate2D)puntoNO
                                  Y:(CLLocationCoordinate2D)puntoSE
                        WithSuccess:(void (^)(id results))success
                            AndFail:(void (^)(NSError *error))fail;
-(void)requestBuscarConZonaID:(NSNumber *)id_zona
                   YSubZonaID:(NSNumber *)id_sub_zona
                 YCategoriaID:(NSNumber *)id_categoria
                       YTexto:(NSString *)texto
                  WithSuccess:(void (^)(NSArray *results))success
                      AndFail:(void (^)(NSError *error))fail;
-(void)requestZonasYSubZonasWithSuccess:(void (^)(NSDictionary *results))success
                                AndFail:(void (^)(NSError *error))fail;
-(void)requestCategoriasWithSuccess:(void (^)(NSArray *results))success
                       AndFail:(void (^)(NSError *error))fail;
-(void) requestCompletarInformacionPuntoCulturalConIDPunto:(NSNumber *)id_punto
                                                AndSuccess:(void (^)(NSDictionary *informacionPunto))success
                                                   AndFail:(void (^)(NSError *error))fail;
-(void)requestDescargarImagenAsincronaWithURLString:(NSString *)url_string
                                            success:(void (^)(id results, NSError *error))block
                              downloadProgressBlock:(void (^) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock;
-(void)requestAgregarPuntoId:(NSNumber *)id_punto
       AMisPuntosWithSuccess:(void (^)())success
                     AndFail:(void (^)(NSError *error))fail;
-(void)requestEliminarPuntoId:(NSNumber *)id_punto
       DeMisPuntosWithSuccess:(void (^)())success
                      AndFail:(void (^)(NSError *error))fail;
-(void)requestMisPuntosCulturalesWithSuccess:(void (^)(NSArray *misPuntosCulturales))success
                                     AndFail:(void (^)(NSError *error))fail;
-(void)requestCambiarEstadoPuntoCulturalID:(NSNumber *)id_punto
                               WithSuccess:(void (^)())success
                                   AndFail:(void (^)(NSError *error))fail;
@end
