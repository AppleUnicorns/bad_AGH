#import <Foundation/Foundation.h>
#import "fetcher.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // === OSOBY ===
        NSString *peopleURL = @"http://letsplay.ag3nts.org/data/osoby.json?v=1743591162";
        NSArray *people = [JSONFetcher fetchArrayFromURL:peopleURL];
        NSMutableDictionary<NSNumber *, NSDictionary *> *peopleById = [NSMutableDictionary dictionary];

        NSLog(@"--- Osoby ---");
        for (NSDictionary *person in people) {
            NSNumber *osobaID = person[@"id"] ?: @(0);
            peopleById[osobaID] = person;
            NSLog(@"%@: %@ %@ – %@ (%@)", osobaID, person[@"imie"], person[@"nazwisko"], person[@"uczelnia"], person[@"miasto"]);
        }

        // === BADANIA ===
        NSString *researchURL = @"http://letsplay.ag3nts.org/data/badania.json?v=1743591162";
        NSArray *researches = [JSONFetcher fetchArrayFromURL:researchURL];

        NSLog(@"\n--- Badania ---");
        for (NSDictionary *entry in researches) {
            NSNumber *osobaID = entry[@"osoba_id"];
            NSDictionary *person = peopleById[osobaID];
            NSString *fullname = person ? [NSString stringWithFormat:@"%@ %@", person[@"imie"], person[@"nazwisko"]] : @"(nieznana osoba)";
            NSLog(@"[%@] %@ → %@ (%@): %@", osobaID, fullname, entry[@"nazwa"], entry[@"data"], entry[@"rezultat"]);
        }
    }
    return 0;
}
