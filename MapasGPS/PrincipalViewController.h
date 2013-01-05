//
//  PrincipalViewController.h
//  MapasGPS
//
//  Created by Rafael Brigagão Paulino on 14/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PrincipalViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapa;
@property (nonatomic, weak) IBOutlet UISegmentedControl *tipoMapa;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnNovoPino;

-(IBAction)ondeEstouClicado:(id)sender;
-(IBAction)minhaCasaClicado:(id)sender;
-(IBAction)tipoMapaDeveMudar:(id)sender;
-(IBAction)novoPino:(id)sender;

@end
