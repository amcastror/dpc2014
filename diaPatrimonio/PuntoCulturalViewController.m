//
//  PuntoCulturalViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCulturalViewController.h"
#import "MisPuntosCulturales.h" 
#import "ShareViewController.h"
#import "Filtros.h"
#import "DejarComentarioViewController.h"
#import "ComentariosViewController.h"

#define bordeInferior 5
#define fuenteTitulo [UIFont fontWithName:@"Helvetica-Bold" size:21]
#define fuenteZona [UIFont fontWithName:@"Arial-BoldMT" size:14]
#define fuenteCategoria [UIFont fontWithName:@"Helvetica" size:16]
#define fuenteDescripciones [UIFont systemFontOfSize:17.0]
#define fuenteInformacion [UIFont systemFontOfSize:17.0]
#define fuenteTituloComentarios [UIFont systemFontOfSize:17.0]
#define fuenteNombreComentarios [UIFont systemFontOfSize:12.0]
#define fuenteFecha [UIFont systemFontOfSize:12.0]
#define colorTitulo [UIColor colorWithRed: 22.0/255.0 green: 82.0/255.0 blue: 158.0/255.0 alpha: 1.0]
#define colorZona [UIColor colorWithRed: 0.0/255.0 green: 0.0/255.0 blue: 0.0/255.0 alpha: 1.0]
#define colorDescripciones [UIColor colorWithRed: 20.0/255.0 green: 20.0/255.0 blue: 20.0/255.0 alpha: 1.0]
#define colorInformacion [UIColor colorWithRed: 20.0/255.0 green: 20.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorTituloComentarios [UIColor colorWithRed: 0.0/255.0 green: 0.0/255.0 blue: 0.0/255.0 alpha: 1.0]
#define colorNombreComentarios [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorFecha [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]

@interface PuntoCulturalViewController (){
    PuntoCultural *puntoCultural;
    int largoActualFicha;
}

@end

@implementation PuntoCulturalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        puntoCultural = _puntoCultural;
        largoActualFicha = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando..."];
    [puntoCultural requestCompletarInformacionWithSuccess:^{
        [self actualizaDisplay];
        [DejalBezelActivityView removeViewAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self actualizaDisplayBotonAccion];
}

#pragma mark - funciones display

-(void) actualizaDisplay{
    //imagen
    if (puntoCultural.url_foto) {
        NSLog(@"url: %@", puntoCultural.url_foto);
        ImagenAsincrona *foto = [[ImagenAsincrona alloc] initWithFrame:CGRectMake(0, 0, 320, 180) AndURL:puntoCultural.url_foto AndStartNow:YES];
        foto.backgroundColor = [UIColor clearColor];
        largoActualFicha = 180 + bordeInferior;
        [self actualizaLargoScroll];
        [scroll addSubview:foto];
    }
    
    // imagen categoria
    
    UIImageView *icono_categoria = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualFicha, 22, 20)];
    
    //Label categoria
    
    UILabel *label_categoria = [[UILabel alloc] initWithFrame:CGRectMake(50, largoActualFicha, 200, 20)];
    label_categoria.backgroundColor = [UIColor clearColor];
    label_categoria.font = fuenteCategoria;
    
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-apertura-02"];
            label_categoria.text = @"Apertura";
            break;
        case TIPO_RECORRIDO_GUIADO:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-recorrido-02"];
            label_categoria.text = @"Recorrido guiado";
            break;
        case TIPO_RUTA_TEMATICA:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-rutas-02"];
            label_categoria.text = @"Ruta temática";
            break;
        case TIPO_ACTIVIDAD:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-actividad-02"];
            label_categoria.text = @"Actividad";
            break;
            
        default:
            break;
    }
    
    
    largoActualFicha = icono_categoria.frame.origin.y + icono_categoria.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:icono_categoria];
    [scroll addSubview:label_categoria];
    
    //separador
    UIImageView *separador = [[UIImageView alloc] initWithFrame:CGRectMake(0, largoActualFicha, 320, 2)];
    separador.image = [UIImage imageNamed:@"ficha-linea-punto-01"];
    
    largoActualFicha = largoActualFicha + 2 + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:separador];
    
    //titulo
    
    CGSize size_nombre = [puntoCultural.nombre sizeWithFont:fuenteTitulo
                                          constrainedToSize:CGSizeMake(280, 100000)
                                              lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *nombre = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_nombre.height)];
    nombre.text = puntoCultural.nombre;
    nombre.numberOfLines = 0;
    nombre.font = fuenteTitulo;
    nombre.textColor = colorTitulo;
    nombre.backgroundColor = [UIColor clearColor];
    
    largoActualFicha = nombre.frame.origin.y + nombre.frame.size.height;
    [self actualizaLargoScroll];
    [scroll addSubview:nombre];
    
    //zona y sub zona
    NSString *string_zona = [NSString stringWithFormat:@"%@ | %@",
                             [[Filtros instance] nombreZonaConIDSubZona:puntoCultural.id_sub_zona],
                             [[Filtros instance] nombreSubZonaConIDSubZona:puntoCultural.id_sub_zona]];
    CGSize size_zona = [string_zona sizeWithFont:fuenteZona
                                          constrainedToSize:CGSizeMake(280, 100000)
                                              lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *zona = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_zona.height)];
    zona.text = string_zona;
    zona.font = fuenteZona;
    zona.textColor = colorZona;
    zona.backgroundColor = [UIColor clearColor];
    
    largoActualFicha = zona.frame.origin.y + zona.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:zona];
    
    UIImage *fondo_resizable = [[UIImage imageNamed:@"ficha-img-fondo-01"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];

    //Descripción corta
    
    CGSize size_descripcion_corta = [puntoCultural.descripcion sizeWithFont:fuenteDescripciones
                                                          constrainedToSize:CGSizeMake(260, 100000)
                                                              lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *descripcion_corta = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, size_descripcion_corta.height)];
    descripcion_corta.text = puntoCultural.descripcion;
    descripcion_corta.font = fuenteDescripciones;
    descripcion_corta.textColor = colorDescripciones;
    descripcion_corta.backgroundColor = [UIColor clearColor];
    descripcion_corta.numberOfLines = 0;
    descripcion_corta.lineBreakMode = UILineBreakModeWordWrap;
    
    UIImageView *descripcion_corta_view = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, 20 + size_descripcion_corta.height + 20)];
    descripcion_corta_view.image = fondo_resizable;
    [descripcion_corta_view addSubview:descripcion_corta];
    
    largoActualFicha = descripcion_corta_view.frame.origin.y + descripcion_corta_view.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:descripcion_corta_view];
    
    //Dirección
    
    largoActualFicha += 10;
    
    CGSize size_direccion = [[NSString stringWithFormat:@"Dirección: %@", puntoCultural.direccion] sizeWithFont:fuenteInformacion
                                          constrainedToSize:CGSizeMake(280, 100000)
                                              lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *direccion = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_direccion.height)];
    direccion.text = [NSString stringWithFormat:@"Dirección: %@", puntoCultural.direccion];
    direccion.font = fuenteInformacion;
    direccion.textColor = colorInformacion;
    direccion.backgroundColor = [UIColor clearColor];
    
    largoActualFicha = direccion.frame.origin.y + direccion.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:direccion];
    
    //Horarios, sitio web, etc.
    
    largoActualFicha += 10;
    
    //Descripción larga
    
    CGSize size_descripcion_larga = [puntoCultural.descripcion_larga sizeWithFont:fuenteDescripciones
                                                          constrainedToSize:CGSizeMake(260, 100000)
                                                              lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *descripcion_larga = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, size_descripcion_larga.height)];
    descripcion_larga.text = puntoCultural.descripcion_larga;
    descripcion_larga.font = fuenteDescripciones;
    descripcion_larga.textColor = colorDescripciones;
    descripcion_larga.backgroundColor = [UIColor clearColor];
    descripcion_larga.numberOfLines = 0;
    descripcion_larga.lineBreakMode = UILineBreakModeWordWrap;
    
    UIImageView *descripcion_larga_view = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, 20 + size_descripcion_larga.height + 20)];
    descripcion_larga_view.image = fondo_resizable;
    [descripcion_larga_view addSubview:descripcion_larga];
    
    largoActualFicha = descripcion_larga_view.frame.origin.y + descripcion_larga_view.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:descripcion_larga_view];
    
    [puntoCultural requestComentariosWithSuccess:^{
        
        int cantidad_comentarios = [[puntoCultural comentarios] count];
        
        if (cantidad_comentarios > 0) {
            //separador
            UIImageView *separador = [[UIImageView alloc] initWithFrame:CGRectMake(0, largoActualFicha, 320, 2)];
            separador.image = [UIImage imageNamed:@"ficha-linea-punto-01"];
            
            largoActualFicha = largoActualFicha + 2 + bordeInferior;
            [self actualizaLargoScroll];
            [scroll addSubview:separador];
            
            
            //La gente comenta
            CGSize size_titulo_comentarios = [@"La gente comenta" sizeWithFont:fuenteTituloComentarios
                                                             constrainedToSize:CGSizeMake(280, 100000)
                                                                 lineBreakMode:UILineBreakModeTailTruncation];
            UILabel *titulo_comentarios = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_titulo_comentarios.height)];
            titulo_comentarios.text = @"La gente comenta";
            titulo_comentarios.font = fuenteTituloComentarios;
            titulo_comentarios.textColor = colorTituloComentarios;
            titulo_comentarios.backgroundColor = [UIColor clearColor];
            
            largoActualFicha = titulo_comentarios.frame.origin.y + titulo_comentarios.frame.size.height + bordeInferior;
            [self actualizaLargoScroll];
            [scroll addSubview:titulo_comentarios];
            
            // Comentarios
            for (int i = 0; i < MIN(4, cantidad_comentarios); i++) {
                
                CGSize size_comentario = [[(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"comentario"] sizeWithFont:fuenteDescripciones
                                                                                                                              constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                                  lineBreakMode:UILineBreakModeTailTruncation];
                
                UILabel *comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, size_comentario.height)];
                comentario.text = [(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"comentario"];
                comentario.font = fuenteDescripciones;
                comentario.textColor = colorDescripciones;
                comentario.backgroundColor = [UIColor clearColor];
                comentario.numberOfLines = 0;
                comentario.lineBreakMode = UILineBreakModeWordWrap;
                
                CGSize size_nombre_comentario = [[(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"autor"] sizeWithFont:fuenteNombreComentarios
                                                                                                                                constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                                    lineBreakMode:UILineBreakModeTailTruncation];
                UILabel *nombre_comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, comentario.frame.origin.y + comentario.frame.size.height + 5, 260, size_nombre_comentario.height)];
                nombre_comentario.text = [(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"autor"];
                nombre_comentario.font = fuenteNombreComentarios;
                nombre_comentario.textColor = colorNombreComentarios;
                nombre_comentario.backgroundColor = [UIColor clearColor];
                nombre_comentario.numberOfLines = 1;
                nombre_comentario.lineBreakMode = UILineBreakModeTailTruncation;
                
                
                
                CGSize size_fecha = [[(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"fecha"] sizeWithFont:fuenteFecha
                                                                                                                    constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                        lineBreakMode:UILineBreakModeTailTruncation];
                UILabel *fecha_comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, nombre_comentario.frame.origin.y + nombre_comentario.frame.size.height + 5, 260, size_fecha.height)];
                fecha_comentario.text = [(NSDictionary *)[puntoCultural.comentarios objectAtIndex:i] objectForKey:@"fecha"];
                fecha_comentario.font = fuenteFecha;
                fecha_comentario.textColor = colorFecha;
                fecha_comentario.backgroundColor = [UIColor clearColor];
                fecha_comentario.numberOfLines = 1;
                fecha_comentario.lineBreakMode = UILineBreakModeTailTruncation;
                
                UIImageView *comentario_view = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, fecha_comentario.frame.origin.y + size_fecha.height + 10)];
                comentario_view.image = fondo_resizable;
                [comentario_view addSubview:comentario];
                [comentario_view addSubview:nombre_comentario];
                [comentario_view addSubview:fecha_comentario];
                
                largoActualFicha = comentario_view.frame.origin.y + comentario_view.frame.size.height;
                [self actualizaLargoScroll];
                [scroll addSubview:comentario_view];
            }
            
            if (cantidad_comentarios > 4) {
                //Agrego el boton de ver más comentarios.
                
                UIButton *ver_todos = [UIButton buttonWithType:UIButtonTypeCustom];
                [ver_todos setBackgroundImage:fondo_resizable forState:UIControlStateNormal];
                CGRect frame = CGRectMake(20, largoActualFicha, 280, 70);
                ver_todos.frame = frame;
                ver_todos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [ver_todos setTitle:@"Ver todos los comentarios" forState:UIControlStateNormal];
                [ver_todos setTitleColor:colorDescripciones forState:UIControlStateNormal];
                [ver_todos addTarget:self action:@selector(verTodosPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                largoActualFicha = ver_todos.frame.origin.y + ver_todos.frame.size.height + bordeInferior;
                [self actualizaLargoScroll];
                [scroll addSubview:ver_todos];
            }
        }
        
    } AndFail:^(NSError *error) {
        //
    }];
}

-(void) verTodosPressed:(id)sender{
    ComentariosViewController *comentarios = [[ComentariosViewController alloc] initWithNibName:@"ComentariosViewController" bundle:[NSBundle mainBundle] AndComentarios:[puntoCultural comentarios]];
    [self.navigationController pushViewController:comentarios animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Ficha" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    [self.navigationItem setBackBarButtonItem:atras];
}

-(void) actualizaLargoScroll{
    [scroll setContentSize:CGSizeMake(320, largoActualFicha)];
}

-(void) actualizaDisplayBotonAccion{
    
    //ahora actualizo los fondos de los botones
    UIImage *default_image_01;
    UIImage *default_image_02;
    UIImage *default_image_03;
    UIImage *selected_image_01;
    UIImage *selected_image_02;
    UIImage *selected_image_03;
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-aper-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-aper-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-aper-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-aper-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-aper-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-aper-03-over"];
            break;
        
        case TIPO_ACTIVIDAD:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-activ-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-activ-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-activ-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-activ-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-activ-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-activ-03-over"];
            break;
        
        case TIPO_RUTA_TEMATICA:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-rutas-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-rutas-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-rutas-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-rutas-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-rutas-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-rutas-03-over"];
            break;
            
        case TIPO_RECORRIDO_GUIADO:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-recorridos-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-recorridos-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-recorridos-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-recorridos-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-recorridos-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-recorridos-03-over"];
            break;
        default:
            break;
    }
    
    [botonCompartir setBackgroundImage:default_image_01 forState:UIControlStateNormal];
    [botonCompartir setBackgroundImage:selected_image_01 forState:UIControlStateHighlighted];
    [botonComentar setBackgroundImage:default_image_02 forState:UIControlStateNormal];
    [botonComentar setBackgroundImage:selected_image_02 forState:UIControlStateHighlighted];
    [botonAccionPunto setBackgroundImage:default_image_03 forState:UIControlStateNormal];
    [botonAccionPunto setBackgroundImage:selected_image_03 forState:UIControlStateHighlighted];
    
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        if (puntoCultural.visitado) {
            [botonAccionPunto setTitle:@"   No visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"   No visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"   No visitado" forState:UIControlStateHighlighted];
        }else{
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateHighlighted];
        }
    }else{
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateNormal];
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateSelected];
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateHighlighted];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//[[[UIAlertView alloc] initWithTitle:@"error" message:@"Sí hay conexión!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
#pragma mark - acciones del punto

- (IBAction)botonAccionPuntoPressed:(id)sender{
    
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        [puntoCultural cambiarEstadoPuntoWithSuccess:^{
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
            if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
                if (puntoCultural.visitado) {
                    [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar marcado como visitado" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar marcado como no visitado" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar agregado a tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        } AndFail:^(NSError *error) {
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ocurrió un error, intenta de nuevo más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }];
        
    }else{
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Agregando punto..."];
        if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Este lugar ya está dentro de tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        [[MisPuntosCulturales instance] agregarPuntoCultural:puntoCultural AMisPuntosWithSuccess:^{
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
            [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar agregado a tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ocurrió un error, intenta de nuevo más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }];
    }
    
}

- (IBAction)botonCompartirEnRedesSocialesPressed:(id)sender{
    ShareViewController *share = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:[NSBundle mainBundle]];
    [[self navigationController] pushViewController:share
                                           animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Ficha" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    [self.navigationItem setBackBarButtonItem:atras];
}

- (IBAction)botonComentarioPressed:(id)sender{
    DejarComentarioViewController *comentario = [[DejarComentarioViewController alloc] initWithNibName:@"DejarComentarioViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural];
    [self.navigationController presentViewController:comentario animated:YES completion:^{
        //
    }];
}

@end
