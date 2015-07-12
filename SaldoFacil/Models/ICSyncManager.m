//
//  ICSyncManager.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/14/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "ICSyncManager.h"

@interface ICSyncManager ()
@property (nonatomic, strong) NSURL *cloudStoreFile;
@property (nonatomic, strong) NSURL *localStoreFile;
@end

@implementation ICSyncManager

+ (ICSyncManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static ICSyncManager  *sharedManager;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (void)checkCloudToken
{
    id currentToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (currentToken) {
        DDLogInfo(@"iCloud access on with id %@", currentToken);
    
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        fileManager.delegate = self;
        
        NSError* error = nil;
        
        
        self.cloudStoreFile = [[NSFileManager defaultManager]  URLForUbiquityContainerIdentifier:@"56N7W5W933.com.bonates.SaldoFacil"];
        
    
        self.cloudStoreFile = [self.cloudStoreFile URLByAppendingPathComponent:@"data"];
        BOOL dataFolderExists = [fileManager fileExistsAtPath:[self.cloudStoreFile path]];
        if (!dataFolderExists) {
            DDLogInfo(@"DATA FOLDER NAO EXISTE AINDA");
            BOOL dataFolderCriada = [fileManager createDirectoryAtPath:[self.cloudStoreFile path] withIntermediateDirectories:YES attributes:nil error:&error];
            
            if (dataFolderCriada) {
                DDLogInfo(@"DATA FOLDER foi criada agorinha!");
            }
        }
        
        
        self.cloudStoreFile = [self.cloudStoreFile URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
        
        
        self.localStoreFile = [NSPersistentStore MR_defaultLocalStoreUrl];
        self.localStoreFile = [[self.localStoreFile URLByDeletingLastPathComponent] URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
        
        
       
        BOOL iCloudFileExists = [fileManager fileExistsAtPath:[self.cloudStoreFile path]];
        BOOL localFileExists = [fileManager fileExistsAtPath:[self.localStoreFile path]];
        
//        DDLogInfo(@"coreDataCloudContent: %@", [coreDataCloudContent path]);
//        DDLogInfo(@"defaultStorePath: %@", [defaultStorePath path]);
        
        DDLogInfo(@"iCloudFileExists: %d", iCloudFileExists);
        DDLogInfo(@"localFileExists: %d", localFileExists);
        
        // somente local
         if (!iCloudFileExists && localFileExists) {
             
             
             if (![fileManager copyItemAtURL:self.localStoreFile toURL:self.cloudStoreFile error:&error]) {
                 DDLogInfo(@"NAO FOI POSSIVEL COPIAR O ARQUIVO. ERRO: %@", error);
             }
             else
             {
                 DDLogInfo(@"ARQUIVO COPIADO PRAS NUVENS");

             }
         }
        
        // somente no icloud
        
        else if(iCloudFileExists && !localFileExists)
        {
            if (![fileManager copyItemAtURL:self.cloudStoreFile toURL:self.localStoreFile error:&error]) {
                DDLogInfo(@"NAO FOI POSSIVEL COPIAR O ARQUIVO. ERRO: %@", error);
            }
            else
            {
                DDLogInfo(@"ARQUIVO COPIADO DO iCLOUD PARA LOCAL");
                
            }
            
        }

        // ambos existem, verificar o mais recente.
        
        else if(iCloudFileExists && localFileExists)
        {
        
        
            NSDictionary *iCloudFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.cloudStoreFile path] error:nil];
            NSDictionary *localFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.localStoreFile path] error:nil];
        
            NSDate *iCloudDate = [iCloudFileAttributes fileModificationDate];
            NSDate *localDate = [localFileAttributes fileModificationDate];
        
        if ([iCloudDate compare:localDate] == NSOrderedDescending) { //iCloudDate eh mais recente
            
        }
        
        if (![fileManager copyItemAtURL:self.cloudStoreFile toURL:self.localStoreFile error:&error]) {
            DDLogInfo(@"NAO FOI POSSIVEL COPIAR O ARQUIVO. ERRO: %@", error);
        }
        else
            {
            DDLogInfo(@"ARQUIVO COPIADO DO iCLOUD PARA LOCAL");
            
            }
        
        }
        
        else
            
            {
            if (![fileManager copyItemAtURL:self.localStoreFile toURL:self.cloudStoreFile error:&error]) {
                DDLogInfo(@"NAO FOI POSSIVEL COPIAR O ARQUIVO. ERRO: %@", error);
            }
            else
                {
                DDLogInfo(@"ARQUIVO COPIADO PRAS NUVENS");
                
                }
            }
        
        
        
    } else {
        DDLogInfo(@"No iCloud access");
        
    }
    
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

@end
