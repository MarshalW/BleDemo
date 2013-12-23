//
//  ViewController.m
//  BleDemo
//
//  Created by Marshal Wu on 13-12-23.
//  Copyright (c) 2013年 Marshal Wu. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


static NSString * const kCharacteristicUUID = @"FECFFCB5-A219-422D-AF92-6370099EB808";
static NSString * const kServiceUUID = @"DF3AAF91-0BB3-4C81-B7CE-CFC8BEB3ECCA";

@interface ViewController () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBMutableService *service;
@property (strong, nonatomic) CBPeripheralManager *peripheralManger;
@property (strong, nonatomic) CBMutableCharacteristic *characteristic;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.peripheralManger=[[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    CBUUID *characteristicUUID =nil;
    CBUUID *serviceUUID =nil;
    
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@">>>设备支持BLE");
            
            characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
            self.characteristic= [[CBMutableCharacteristic alloc] initWithType:
                                  characteristicUUID properties:CBCharacteristicPropertyNotify
                                                                         value:nil permissions:CBAttributePermissionsReadable];
            serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
            self.service=[[CBMutableService alloc] initWithType:serviceUUID
                                                        primary:YES];
            [self.service setCharacteristics:@[self.characteristic]];
            [self.peripheralManger addService:self.service];
            
            
            break;
        default:
            NSLog(@">>>设备不支持BLE");
            break;
    }
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error == nil) {
        [self.peripheralManger startAdvertising:@{ CBAdvertisementDataLocalNameKey : @"MarshalServer", CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:kServiceUUID]] }];
        NSLog(@">>>开始发送advertising");
    }
}


@end
