#import <Foundation/Foundation.h>
#import "JSONFetcher.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // === Pobierz wszystkie 3 źródła ===
        NSString *osobyURL = @"http://letsplay.ag3nts.org/data/osoby.json?v=1743591162";
        NSString *badaniaURL = @"http://letsplay.ag3nts.org/data/badania.json?v=1743591162";
        NSString *uczelnieURL = @"http://letsplay.ag3nts.org/data/uczelnie.json?v=1743591162";

        NSArray *osoby = [JSONFetcher fetchArrayFromURL:osobyURL];
        NSArray *badania = [JSONFetcher fetchArrayFromURL:badaniaURL];
        NSArray *uczelnie = [JSONFetcher fetchArrayFromURL:uczelnieURL];

        // === Ścieżki do plików ===
        NSString *basePath = @"/Users/pati/Documents/Apple i IT/programy/CTF-dev/CTF-dev/CTF-dev/wyniki/";
        NSString *osobyPath = [basePath stringByAppendingPathComponent:@"osoby.plist"];
        NSString *badaniaPath = [basePath stringByAppendingPathComponent:@"badania.plist"];
        NSString *uczelniePath = [basePath stringByAppendingPathComponent:@"uczelnie.plist"];

        // === Funkcja pomocnicza ===
        void (^zapisz)(NSArray *, NSString *) = ^(NSArray *dane, NSString *sciezka) {
            NSError *err = nil;
            NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:dane
                                                                           format:NSPropertyListXMLFormat_v1_0
                                                                          options:0
                                                                            error:&err];
            if (plistData) {
                BOOL ok = [plistData writeToFile:sciezka atomically:YES];
                if (ok) {
                    NSLog(@"✅ Zapisano: %@", sciezka);
                } else {
                    NSLog(@"❌ Nie zapisano pliku: %@", sciezka);
                }
            } else {
                NSLog(@"❌ Błąd serializacji (%@): %@", sciezka, err.localizedDescription);
            }
        };

        // === Zapisz wszystkie 3 ===
        zapisz(osoby, osobyPath);
        zapisz(badania, badaniaPath);
        zapisz(uczelnie, uczelniePath);
    }
    return 0;
}
