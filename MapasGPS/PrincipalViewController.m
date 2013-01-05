//
//  PrincipalViewController.m
//  MapasGPS
//
//  Created by Rafael Brigagão Paulino on 14/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "PrincipalViewController.h"

@interface PrincipalViewController ()
{
    MKPointAnnotation *minhaCasaAnotacao;
    
    MKPointAnnotation *ondeEstouAnotacao;
    
    CLLocationManager *gerenciadorLocalizacao;
    
    CGPoint pontoSelecionadoMapa;
}

@end

@implementation PrincipalViewController

-(IBAction)novoPino:(id)sender
{
    if (_mapa.userInteractionEnabled)
    {
        [_btnNovoPino setTitle:@"Finalizar"];
    }
    else
    {
       [_btnNovoPino setTitle:@"Adicionar Pino"]; 
    }
    //invertendo a condicao da variavel booleana que define se o usuario pode interar com o mapa ou nao
    //passamos para no para que o evento de toque  a tela seja capturado
    _mapa.userInteractionEnabled = !_mapa.userInteractionEnabled;
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *toqueTela = [touches anyObject];
    //descobrindo o ponto onde o mapa foi tocado
    pontoSelecionadoMapa = [toqueTela locationInView:_mapa];
    
    //cria o pino
    MKPointAnnotation *novoPino = [[MKPointAnnotation alloc] init];
    //associando a coordenada do novoPino a uma coordenada criada a partir do ponto tocado no mapa
    novoPino.coordinate = [_mapa convertPoint:pontoSelecionadoMapa toCoordinateFromView:_mapa];
    
    [_mapa addAnnotation:novoPino];
    
    NSLog(@"Toque na tela");
    
}
                                    
                                    

-(IBAction)ondeEstouClicado:(id)sender
{
   //verificar se o aparelho que eu estou usando possui GPS disponivel
    if ([CLLocationManager locationServicesEnabled])
    {
        //estou verificando se ja existe um location manager alocado
        if (gerenciadorLocalizacao == nil)
        {
            //caso nao exista eu crio um
            gerenciadorLocalizacao = [[CLLocationManager alloc] init];
            //objetos da classe CLLocationManager entregam as informacoes sobre a localizacao desejada por delegate
            gerenciadorLocalizacao.delegate = self;
        }
        //solicitando que o locationManager inicie o trabalho de monitorar a localizacao e chamar os metodos delegate nesta classe que foi protocolocada com  CLLocationManagerDelegate (.h)
        [gerenciadorLocalizacao startUpdatingLocation];
        
        
    }
}

//metodo chamado toda vez que o gerenciadorLocalizacao perceber uma veriacao da latitude e longitude do usuario
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //centralizar o mapa nesta nova localizacao do usuario
    MKCoordinateSpan zoom = MKCoordinateSpanMake(0.001,0.001);
    
    MKCoordinateRegion regiao = MKCoordinateRegionMake(newLocation.coordinate, zoom);
    
    
    //adicionar uma marcacao no mapa
    //criando o pino
    ondeEstouAnotacao = [[MKPointAnnotation alloc] init];
    
    //ao alterar alguma informacao que deve ser exibida
    ondeEstouAnotacao.title = @"Minha localizacao";
    

    //onde o pino sera adicionado
    ondeEstouAnotacao.coordinate = newLocation.coordinate;
    
    //busca por informacoes acerca de uma localizacao
    //CLGeocoder ->fazer a codificacao de uma localizacao trazendo informacoes relevantes
    CLGeocoder *meuCodificadorMapas = [[CLGeocoder alloc] init];
    
    //metodo do clgocoder onde passamos uma cllocation e recebemos suas info pelo bloco completionhandler
    [meuCodificadorMapas reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //precisamos garantir que so temos um placemark
        if (placemarks.count == 1)
        {
            //criando um novo placdemark que vai conter  as informacoes do unico placemark contido no vetor de resposta, indice 0
            //ajustar o anotation
            CLPlacemark *infoLocalAtual = [[CLPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
            
            ondeEstouAnotacao.title = infoLocalAtual.thoroughfare;
            ondeEstouAnotacao.subtitle = infoLocalAtual.administrativeArea;
            
            //adiciona o pino no mapa
            [_mapa addAnnotation:ondeEstouAnotacao];
        }
        else
        {
            //tratar situacao onde temos mais de um placemark
            //exemplo:exibir uma lista para o usuario para que ele escolha a informacao
        }
    }];
    
    
    [_mapa setRegion:regiao animated:YES];
    
    //parando a leitura do GPS
    [gerenciadorLocalizacao stopUpdatingLocation];
    
}


-(IBAction)minhaCasaClicado:(id)sender
{
    //-23.5650193 -46.6519977
    CLLocationCoordinate2D localizacaoCasa = CLLocationCoordinate2DMake(-23.5650193, -46.6519977);
    
    //zoom
    MKCoordinateSpan zoom = MKCoordinateSpanMake(0.001, 0.001);
    
    //posicionar o mapa: onde+zoom =>regiao
    MKCoordinateRegion regiao = MKCoordinateRegionMake(localizacaoCasa, zoom);
    //solicitando ao mapra para mudar de regiao
    [_mapa setRegion:regiao animated:YES];
    
    
    //adicionar uma marcacao no mapa
    //criando o pino
    minhaCasaAnotacao = [[MKPointAnnotation alloc] init];
    
    //ao alterar alguma informacao que deve ser exibida no balao ele aparece ao clicar no pino
    minhaCasaAnotacao.title = @"Minha casa";
    
    //onde o pino sera adicionado
    minhaCasaAnotacao.coordinate = localizacaoCasa;
    //adiciona o pino no mapa
    [_mapa addAnnotation:minhaCasaAnotacao];
    
}
-(IBAction)tipoMapaDeveMudar:(id)sender
{
    if (_tipoMapa.selectedSegmentIndex == 0)
    {
        _mapa.mapType = MKMapTypeStandard;
    }
    else if (_tipoMapa.selectedSegmentIndex == 1)
    {
        _mapa.mapType = MKMapTypeHybrid;

    }
    else if (_tipoMapa.selectedSegmentIndex == 2)
    {
        _mapa.mapType = MKMapTypeSatellite;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
